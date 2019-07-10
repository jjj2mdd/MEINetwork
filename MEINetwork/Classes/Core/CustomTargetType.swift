//
//  CustomTargetType.swift
//  MEINetwork
//
//  Created by maochaolong041 on 2019/4/18.
//  Copyright (c) 2019 maochaolong041. All rights reserved.
//

import Moya

/// 自定义Target
public protocol CustomTargetType: TargetType, Configurable {}

extension CustomTargetType {

    public var baseURL: URL {
        return Self.environment.baseURL
    }

    public var method: Moya.Method {
        return .get
    }

    public var sampleData: Data {
        return Data()
    }

    public var task: Task {
        return .requestPlain
    }

    public var validationType: ValidationType {
        return .none
    }

    public var headers: [String : String]? {
        return nil
    }

    public var timeoutInterval: TimeInterval {
        return 10.0
    }

}
