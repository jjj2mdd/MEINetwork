//
//  TokenService.swift
//  MEINetwork_Example
//
//  Created by maochaolong041 on 2019/4/18.
//  Copyright (c) 2019 maochaolong041. All rights reserved.
//

import MEINetwork

/// Token获取相关
///
/// - token: Token获取
enum TokenService {
    case token
}

extension TokenService: BaseTargetType {

    var path: String {
        return "app-gateway/token/generate-token"
    }

    var token: String? {
        return nil
    }

}
