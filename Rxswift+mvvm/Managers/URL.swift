//
//  URL.swift
//  GHDemo
//
//  Created by zzh on 2024/10/5.
//

import Foundation
import Moya
import RxSwift

public extension URL {

    /// Initialize URL from Moya's `TargetType`.
    init<T: TargetType>(target: T) {
        // When a TargetType's path is empty, URL.appendingPathComponent may introduce trailing /, which may not be wanted in some cases
        // See: https://github.com/Moya/Moya/pull/1053
        // And: https://github.com/Moya/Moya/issues/1049
        let targetPath = target.path
        if targetPath.isEmpty {
            self = target.baseURL
        }else if target.path.contains("?") {
            // 这里直接强制解包了，这里可以修改，如果你需要。
            self = URL.init(string: target.baseURL.absoluteString + target.path)!
        } else {
            self = target.baseURL.appendingPathComponent(targetPath)
        }
    }
}
public extension MoyaProvider {
    final class func URLEndpointMapping(for target: Target) -> Endpoint {
       return Endpoint(
           url: URL(target: target).absoluteString,
           sampleResponseClosure: { .networkResponse(200, target.sampleData) },
           method: target.method,
           task: target.task,
           httpHeaderFields: target.headers
       )
   }
}
public extension Reactive where Base: MoyaProviderType {
    
    /// Designated request-making method.
    ///
    /// - Parameters:
    ///   - token: Entity, which provides specifications necessary for a `MoyaProvider`.
    ///   - callbackQueue: Callback queue. If nil - queue from provider initializer will be used.
    /// - Returns: Single response object.
    func request(_ token: Base.Target, callbackQueue: DispatchQueue? = nil) -> Single<Result<Response,MoyaError>> {
        Single.create { [weak base] single in
            let cancellableToken = base?.request(token, callbackQueue: callbackQueue, progress: nil) { result in
               single(.success(result))
            }
            return Disposables.create {
                cancellableToken?.cancel()
            }
        }
    }
}






