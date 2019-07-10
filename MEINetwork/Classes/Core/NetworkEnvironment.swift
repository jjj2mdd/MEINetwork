//
//  NetworkEnvironment.swift
//  MEINetwork
//
//  Created by maochaolong041 on 2019/4/18.
//  Copyright (c) 2019 maochaolong041. All rights reserved.
//

import Foundation

/// 网络环境
///
/// - Dev: 内网开发
/// - ExternalDev: 外网开发
/// - SIT: 测试
/// - UAT: 产品测试
/// - Demo: 演示
/// - Product: 线上
public enum NetworkEnvironment {

    case Dev(baseURL: URL, webURL: URL)
    case ExternalDev(baseURL: URL, webURL: URL)
    case SIT(baseURL: URL, webURL: URL)
    case UAT(baseURL: URL, webURL: URL)
    case Demo(baseURL: URL, webURL: URL)
    case Product(baseURL: URL, webURL: URL)

    public var stringValue: String {
        switch self {
        case .Dev(_, _):
            return "Dev"
        case .ExternalDev(_, _):
            return "ExternalDev"
        case .SIT(_, _):
            return "SIT"
        case .UAT(_, _):
            return "UAT"
        case .Demo(_, _):
            return "Demo"
        case .Product(_, _):
            return "Product"
        }
    }

    public var baseURL: URL {
        switch self {
        case let .Dev(baseURL, _):
            return baseURL
        case let .ExternalDev(baseURL, _):
            return baseURL
        case let .SIT(baseURL, _):
            return baseURL
        case let .UAT(baseURL, _):
            return baseURL
        case let .Demo(baseURL, _):
            return baseURL
        case let .Product(baseURL, _):
            return baseURL
        }
    }

    public var webURL: URL {
        switch self {
        case let .Dev(_, webURL):
            return webURL
        case let .ExternalDev(_, webURL):
            return webURL
        case let .SIT(_, webURL):
            return webURL
        case let .UAT(_, webURL):
            return webURL
        case let .Demo(_, webURL):
            return webURL
        case let .Product(_, webURL):
            return webURL
        }
    }

}
