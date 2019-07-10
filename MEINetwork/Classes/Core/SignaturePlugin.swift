//
//  SignaturePlugin.swift
//  MEINetwork
//
//  Created by maochaolong041 on 2019/4/18.
//  Copyright (c) 2019 maochaolong041. All rights reserved.
//

import Moya

/// 网络签名插件
struct SignaturePlugin: PluginType {

    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard let customTarget = target as? CustomTargetType else { return request }

        var newRequest = request
        var header = customTarget.method == .get
            ? request.url?.parse() ?? [String: String]()
            : [String: String]()

        header["A-APPID"] = customTarget.appID
        header["A-DEVICE-ID"] = customTarget.deviceID
        header["A-TOKEN"] = customTarget.token
        header["A-TIMESTAMP"] = timestamp

        // 仅POST请求需要设置
        if customTarget.method == .post {
            header["A-INPUTSTREAM"] = inputStream(with: request)
        }

        header["A-SIGN"] = sign(with: header, salt: customTarget.salt)

        header.forEach {
            newRequest.setValue($1, forHTTPHeaderField: $0)
        }

        newRequest.setValue(customTarget.sessionID, forHTTPHeaderField: "A-SESSION-ID")
        newRequest.timeoutInterval = customTarget.timeoutInterval

        return newRequest
    }

    var timestamp: String  {
        return String(format: "%.0f", Date().timeIntervalSince1970 * 1000)
    }

    func inputStream(with request: URLRequest) -> String? {
        guard let data = request.httpBody else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }

    func sign(with header: [String: String], salt: String) -> String {
        var params = String()

        header.sorted(by: {
            return $0.key < $1.key
        }).forEach {
            params.append("\($0)\($1)")
        }

        let secret = "\(salt)\(params)\(salt)"

        return secret.md5
    }

}

extension URL {

    func parse() -> Dictionary<String, String> {
        var queries: Dictionary<String, String> = [:]
        let components = self.query?.components(separatedBy: "&")

        _ = components?.map {
            if let index = $0.firstIndex(of: "=") {
                let key = String($0[..<index])
                let value = String($0[index...].dropFirst())
                queries[key] = value
            }
        }

        return queries
    }

}
