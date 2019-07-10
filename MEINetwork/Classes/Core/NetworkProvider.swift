//
//  NetworkProvider.swift
//  MEINetwork
//
//  Created by maochaolong041 on 2019/4/18.
//  Copyright (c) 2019 maochaolong041. All rights reserved.
//

import Moya
import Alamofire

private let tokenKey = "CQFAE-NETWORK-TOKEN"
private let errorDomain = "com.cqfae.network"

public typealias DictionaryCompletion = (_ dictionary: [String: Any]?, _ error: Error?) -> Void

public typealias DecodableCompletion<D: Decodable> = (_ decodable: D?, _ error: Error?) -> Void

open class NetworkProvider<Target: TargetType>: MoyaProvider<Target> {

    public init(environment: NetworkEnvironment, callbackQueue: DispatchQueue? = nil) {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Manager.defaultHTTPHeaders

        let apiPolicy: ServerTrustPolicy = (environment.baseURL.scheme ?? "") == "https"
            ? .performDefaultEvaluation(validateHost: false)
            : .disableEvaluation
        let webPolicy: ServerTrustPolicy = (environment.webURL.scheme ?? "") == "https"
            ? .performDefaultEvaluation(validateHost: false)
            : .disableEvaluation
        let baseHost  = environment.baseURL.host!
        let webHost = environment.webURL.host!
        let policies: [String: ServerTrustPolicy] = baseHost == webHost
            ? [baseHost: apiPolicy]
            : [baseHost: apiPolicy, webHost: webPolicy]
        let trustManager = ServerTrustPolicyManager(policies: policies)

        let manager = Manager(configuration: configuration, serverTrustPolicyManager: trustManager)
        manager.startRequestsImmediately = false

        let plugins = [NetworkLoggerPlugin(verbose: true), SignaturePlugin()] as [PluginType]

        super.init(callbackQueue: callbackQueue, manager: manager, plugins: plugins)
    }

    open override func request(_ target: Target, callbackQueue: DispatchQueue? = .none, progress: ProgressBlock? = .none, completion: @escaping Completion) -> Cancellable {
        return super.request(target, callbackQueue: callbackQueue, progress: progress, completion: completion)
    }

    @discardableResult
    open func request(_ target: Target, callbackQueue: DispatchQueue? = .none, progress: ProgressBlock? = .none, dictionaryCompletion: @escaping DictionaryCompletion) -> Cancellable {
        return request(target, callbackQueue: callbackQueue, progress: progress, completion: responseFilter({ response, dictionary, error in
            dictionaryCompletion(dictionary, error)
        }))
    }

    @discardableResult
    open func request<D: Decodable>(_ target: Target, type: D.Type, keyPath: String?, callbackQueue: DispatchQueue? = .none, progress: ProgressBlock? = .none, decodableCompletion: @escaping DecodableCompletion<D>) -> Cancellable {
        return request(target, callbackQueue: callbackQueue, progress: progress, completion: responseFilter({ response, dictionary, error in
            do {
                let decodable = try response?.map(type, atKeyPath: keyPath)
                decodableCompletion(decodable, error)
            } catch let error {
                decodableCompletion(nil, error)
            }
        }))
    }

    public static var token: String? {
        get {
            guard let token = UserDefaults.standard.string(forKey: tokenKey) else { return nil }
            return token
        }
        set {
            UserDefaults.standard.set(newValue, forKey: tokenKey)
        }
    }

    private func responseFilter(_ completion: @escaping (_ response: Response?, _ dictionary: [String: Any]?, _ error: Error?) -> Void) -> Completion {
        return {
            switch $0 {
            case let .success(response):
                let data = response.data

                do {
                    if let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any] {
                        if let resultCode = dictionary["resultCode"] as? String {
                            if ["40100", "40105", "40301"].contains(where: {
                                return $0 == resultCode
                            }) {
                                NetworkProvider.token = nil
                                let error = MoyaError.underlying(NSError(domain: errorDomain, code: -1, userInfo: [NSLocalizedDescriptionKey : "Token失效"]), nil)
                                completion(nil, nil, error)
                            } else if resultCode == "40501" {
                                let error = MoyaError.underlying(NSError(domain: errorDomain, code: -2, userInfo: [NSLocalizedDescriptionKey : "签名不一致"]), nil)
                                completion(nil, nil, error)
                            } else if resultCode == "41003" {
                                let error = MoyaError.underlying(NSError(domain: errorDomain, code: -3, userInfo: [NSLocalizedDescriptionKey : "用户被踢下线"]), nil)
                                completion(nil, nil, error)
                            } else if resultCode == "0000" {
                                completion(response, dictionary, nil)
                            } else {
                                var localizedDescription = "其他类型错误"

                                if let description = dictionary["resultMessage"] as? String {
                                    localizedDescription = description
                                }

                                let error = MoyaError.underlying(NSError(domain: errorDomain, code: -4, userInfo: [NSLocalizedDescriptionKey : localizedDescription]), nil)
                                completion(nil, nil, error)
                            }
                        } else {
                            let error = MoyaError.underlying(NSError(domain: errorDomain, code: 0, userInfo: [NSLocalizedDescriptionKey : "数据异常"]), nil)
                            completion(nil, nil, error)
                        }
                    }
                } catch let error {
                    completion(nil, nil, error)
                }
            case let .failure(error):
                completion(nil, nil, error)
            }
        }
    }

}
