//
//  BaseTargetType.swift
//  MEINetwork_Example
//
//  Created by maochaolong041 on 2019/4/18.
//  Copyright (c) 2019 maochaolong041. All rights reserved.
//

import MEINetwork
import UICKeyChainStore

protocol BaseTargetType: CustomTargetType {}

extension BaseTargetType {

    var path: String {
        return ""
    }

    var appID: String {
        return "TODAY-FINANCE-APP"
    }

    var deviceID: String {
        let service = "com.cqfae.cafae-appstore-deviceid"
        let key = "com.cqfae.cefae-appstore-uuid"
        let keychain = UICKeyChainStore(service: service)

        guard let deviceID = keychain.string(forKey: key) else {
            let newDeviceID = UUID().uuidString
            keychain.setString(newDeviceID, forKey: key)
            return newDeviceID
        }

        return deviceID
    }

    var sessionID: String? {
        return nil
    }

    var token: String? {
        guard let token = NetworkProvider<TokenService>.token else {
            let semaphore: DispatchSemaphore = DispatchSemaphore(value: 0)
            var newToken: String?

            let provider = NetworkProvider<TokenService>(environment: TokenService.environment)

            provider.request(.token, callbackQueue: .global()) {
                if let data = $0?["data"] as? [String : Any],
                    let token = data["token"] as? String {
                    newToken = token
                    NetworkProvider<TokenService>.token = newToken
                }
                if let error = $1 {
                    print(error.localizedDescription)
                }
                semaphore.signal()
            }

            semaphore.wait()

            return newToken
        }

        return token
    }

    var salt: String {
        return "SECRET"
    }

    static var environment: NetworkEnvironment {
        let apiURL = URL(string: "https://218.18.229.172")!
        let webURL = URL(string: "https://app.pazhengfuyun.com/fiscal-spa/#")!
        return .Product(baseURL: apiURL, webURL: webURL)
    }

}
