//
//  Configurable.swift
//  MEINetwork
//
//  Created by maochaolong041 on 2019/4/18.
//  Copyright (c) 2019 maochaolong041. All rights reserved.
//

import Foundation

/// 网络库配置协议
public protocol Configurable {

    /// 应用ID
    var appID: String { get }

    /// 设备ID
    var deviceID: String { get }

    /// 会话ID
    var sessionID: String? { get }

    /// Token值
    var token: String? { get }

    /// Salt值
    var salt: String { get }

    /// 请求超时时间(默认10秒)
    var timeoutInterval: TimeInterval { get }

    /// 网络环境
    static var environment: NetworkEnvironment { get }

}
