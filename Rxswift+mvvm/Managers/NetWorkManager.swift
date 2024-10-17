//
//  NetWorkManager.swift
//  GHDemo
//
//  Created by zzh on 2024/10/5.
//

import Foundation
import UIKit
import Combine
import RxCocoa
import Moya
import RxSwift


class NetWorkManager{
    static let shared = NetWorkManager()
    
    let provider = MoyaProvider<GHService>(endpointClosure:MoyaProvider.URLEndpointMapping)
    
    var cancellables = Set<AnyCancellable>()
    
   // Result<[Follower],MoyaError> 返回方式
    func getFollowersResult(with username:String , page: String) -> Single<Result<[Follower],MoyaError>> {
        return provider.rx.request(.user(username: username, page: page))
            .map({ ( res : Result<Response, MoyaError>) in
                switch res {
                case .success(let model):
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let results = try decoder.decode([Follower].self, from: model.data)
                    return .success(results)
                case .failure(let error):
                    return .failure(error)
                }
            })
            .observe(on: MainScheduler.instance)
    }

    // 普通single 方式需要
    func getFollowers(with username:String , page: String) -> Single<[Follower]> {
        return provider.rx.request(.user(username: username, page: page))
            .filterSuccessfulStatusCodes()
            .map { response in
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let results = try decoder.decode([Follower].self, from: response.data)
                return results
            }
            .observe(on: MainScheduler.instance)
    }
}
