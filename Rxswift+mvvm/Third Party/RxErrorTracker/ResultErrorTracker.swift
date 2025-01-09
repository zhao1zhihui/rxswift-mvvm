//
// Created by sergdort on 03/02/2017.
// Copyright (c) 2017 sergdort. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

final class ResultErrorTracker: SharedSequenceConvertibleType {
    
    typealias SharingStrategy = DriverSharingStrategy
    private let _subject = PublishSubject<Error>()

    func trackError<O: ObservableConvertibleType>(from source: O) -> Observable<O.Element> where O.Element == Result<[TableSectionTitle],MoyaError>{
        return source.asObservable().do(onNext:{ [weak self] (result : O.Element) in
            if let weakSelf = self {
                weakSelf.onNext(element: result)
            }
        })

    }

    func asSharedSequence() -> SharedSequence<SharingStrategy, Error> {
        return _subject.asObservable().asDriverOnErrorJustComplete()
    }

    func asObservable() -> Observable<Error> {
        return _subject.asObservable()
    }
    private func onNext(element:Result<[TableSectionTitle],MoyaError>){
        switch element {
        case .success(let success): break
        case .failure(let failure):
            _subject.onNext(failure);
        }
    }

    private func onError(_ error: Error) {
        _subject.onNext(error)
    }

    deinit {
        _subject.onCompleted()
    }
}

extension ObservableConvertibleType {
    func resultErrorTracker(_ resultErrorTracker: ResultErrorTracker) -> Observable<Element> where Element == Result<[TableSectionTitle],MoyaError> {
        return resultErrorTracker.trackError(from: self)
    }
}
