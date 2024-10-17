//
//  GHMoyaProvider.swift
//  GHDemo
//
//  Created by zzh on 2024/10/5.
//

import Foundation
import Moya
import UIKit

enum GHService {
    case user(username:String, page:String)
    case flower
//    case showUser(id: Int)
//    case createUser(firstName: String, lastName: String)
//    case updateUser(id: Int, firstName: String, lastName: String)
//    case showAccounts
}

extension GHService : TargetType {
    var baseURL: URL { return URL(string: "https://api.github.com")! }

    
    var path: String {
        switch self {
        case let .user(username,page):
            return "/users/\(username)/followers?per_page=100&page=\(page)"
        case .flower:
            return "/users"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .user:
            return .get
        case .flower:
           return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .user: // Send no parameters
            return .requestPlain
        case .flower:
            return .requestParameters(parameters: ["first_name": "firstName", "last_name": "lastName"], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}
private extension String {
    var urlEscaped: String {
        addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    var utf8Encoded: Data {
        Data(self.utf8)
    }
}
