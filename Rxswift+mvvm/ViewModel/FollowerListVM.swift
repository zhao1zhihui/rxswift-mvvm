//
//  FollowerListVC.swift
//  GHDemo
//
//  Created by zzh on 2024/10/5.
//

import Foundation
import RxCocoa
import RxSwift
import Moya
import NSObject_Rx


class FollowerListVM :ViewModel, ViewModelType {
    
    let itembT: PublishSubject<FollowerItem> = PublishSubject<FollowerItem>()
    var text: String = ""
    
    struct Input {
        let search: Observable<String>
        let headerRefresh: Observable<Void>
        let footerRefresh: Observable<Void>
    }
    
    struct Output {
        let items: BehaviorRelay<[TableSectionTitle]>
    }
    
    func transform(input: Input) -> Output {
        
        let elements = BehaviorRelay<[TableSectionTitle]>(value: [])
        
        itembT.subscribe { foller in
            switch foller{
            case .next(let res):
                res.change?.accept(!(res.change!.value))
            case .error(_): break
            case .completed: break
            }
        }.disposed(by: rx.disposeBag)
        
//        input.headerRefresh.flatMapLatest({[weak self] (_) -> Observable<Result<[TableSectionTitle],MoyaError>> in
//            guard let self = self else { return Observable.just(.success([]))}
//            return self.requestresult(text:self.text, page:self.page)
//            .trackActivity(self.headerLoading)})
//        .subscribe { result in
//        switch result{
//        case .next(let res):
//            switch res{
//            case .success(let foller):
//                elements.accept(foller)
//                print("=============")
//            case .failure(let error):
//                print(error.localizedDescription)
//                print("--------------")
//
//            }
//        case .error(_): break
//            
//        case .completed: break
//            
//        }
//    }.disposed(by: disposeBag)
        
        input.footerRefresh.flatMapLatest({[weak self] (_) -> Observable<Result<[TableSectionTitle],MoyaError>> in
            guard let self = self else { return Observable.just(.success([]))}
            self.page = self.page + 1
            return self.requestresult(text:self.text, page:self.page)
                .trackActivity(self.footerLoading)
       })
        .subscribe { result in
        switch result{
        case .next(let res):
            switch res{
            case .success(let foller):
                elements.accept(elements.value + foller)
                print("=============")
            case .failure(let error):
                
                print("--------------")

            }
        case .error(_): break
        case .completed: break
        }
        }.disposed(by: rx.disposeBag)
        
        _ = input.search.flatMapLatest({[weak self] (test) -> Observable<Result<[TableSectionTitle],MoyaError>> in
            guard let self = self else { return Observable.just(.success([]))}
            self.text = test
            self.page = 1
            return self.requestresult(text:test, page:self.page).trackActivity(self.loading)
                })
             .subscribe {[weak self](result) in
                switch result{
                case .next(let res):
                    switch res{
                    case .success(let foller):
                        elements.accept(foller)
                        print("=============")
                    case .failure(let error):
                        print(error.localizedDescription)
                        self?.resultError.onNext(error)
                        print("--------------")

                    }
                case .error(_): break
                    
                case .completed: break
                    
                }
             }.disposed(by: rx.disposeBag
             )
        
        // .materialize().share() .element .error
        input.headerRefresh.flatMapLatest({[weak self] (_) -> Observable<Event<[TableSectionTitle]>> in
            guard let self = self else { return Observable.just(Event.next([])) }
            return self.request()
                .trackActivity(self.headerLoading)
                .trackError(error) // 统一处理错误
                .materialize()
        })
        .subscribe(onNext: {(event) in
            switch event {
            case .next(let result):
                elements.accept(result)
                print("++++++++++++++")
            case .error(let error):
                print("--------------")
                print(error.localizedDescription)
            default: break
            }
        }).disposed(by: rx.disposeBag)

        return Output(items: elements)
    }
    
    func request() -> Observable<[TableSectionTitle]> {
        return NetWorkManager.shared.getFollowers(with: "name", page: "1")
            .map({ [weak self] (res) in
                var followerItems:[FollowerItem] = []
                for foller in res {
                    let item = FollowerItem()
                    item.follower = foller
                    item.elements = self?.itembT
                    let itemchange: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
                    item.change = itemchange
                    followerItems.append(item)
                }
                let section = TableSectionTitle(title: "测试一个titile", items:followerItems.map({ $0.anyTableRowModel}))
                return [section]
            }).asObservable()
    }
    
    func requestresult(text:String, page:Int) -> Observable<Result<[TableSectionTitle],MoyaError>> {
        print("text:\(text)")
        return NetWorkManager
            .shared
            .getFollowersResult(with: text, page: "\(page)")
            .map({ [weak self] (res : Result<[Follower], MoyaError>) in
                switch res {
                case .success(let model):
                    var followerItems:[FollowerItem] = []
                    for foller in model {
                        let item = FollowerItem()
                        item.follower = foller
                        item.elements = self?.itembT
                        let itemchange: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
                        item.change = itemchange
                        followerItems.append(item)
                    }
                    let section = TableSectionTitle(title: "测试一个titile", items:followerItems.map({ $0.anyTableRowModel}))
                    return .success([section])
                case .failure(let error):
                    return .failure(error)
                }
            })
            .asObservable()
    }
    
    
    
}


