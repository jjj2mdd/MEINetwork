//
//  AssistantService.swift
//  MEINetwork_Example
//
//  Created by maochaolong041 on 2019/4/18.
//  Copyright (c) 2019 maochaolong041. All rights reserved.
//

import MEINetwork
import Moya

/// 智库相关
///
/// - instantInternal: 即时内参
/// - customization: 定制智库
enum AssistantService {
    case instantInternal(page: UInt, pageSize: UInt?)
    case customization(name: String, phone: String, requirements: String, achievements: [String], favorites: [String])
}

extension AssistantService: BaseTargetType {

    var path: String {
        switch self {
        case .instantInternal(_, _):
            return "app-gateway/today-finance-app/v2/think-tank/internal-news/list"
        case .customization(_, _, _, _, _):
            return "app-gateway/today-finance-app/v2/think-tank/user-requirement/create"
        }
    }

    var method: Moya.Method {
        switch self {
        case .instantInternal(_, _):
            return .get
        case .customization(_, _, _, _, _):
            return .post
        }
    }

    var task: Task {
        switch self {
        case let .instantInternal(page, pageSize):
            return .requestParameters(parameters: ["pageNumber" : page, "pageSize" : pageSize ?? 10],
                                      encoding: URLEncoding.queryString)
        case let .customization(name, phone, requirements, achievements, favorites):
            return .requestParameters(parameters: ["name" : name, "phone" : phone,
                                                   "requirements" : requirements,
                                                   "achievements" : achievements,
                                                   "favorites" : favorites],
                                      encoding: JSONEncoding.default)
        }
    }

}
