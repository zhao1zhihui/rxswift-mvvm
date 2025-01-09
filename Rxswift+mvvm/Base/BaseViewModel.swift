//
//  BaseViewModel.swift
//  Rxswift+mvvm
//
//  Created by zzh on 2024/10/9.
//

import UIKit
import RxSwift
import Moya

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    func transform(input: Input) -> Output
}

class ViewModel :NSObject {
    var page: Int = 1
    let loading: ActivityIndicator = ActivityIndicator()
    let headerLoading: ActivityIndicator = ActivityIndicator()
    let footerLoading: ActivityIndicator = ActivityIndicator()
    let error: ErrorTracker = ErrorTracker()
    let resultError:PublishSubject<Error> = PublishSubject<Error>()
    
    let tongyiresultError:ResultErrorTracker = ResultErrorTracker()
}
