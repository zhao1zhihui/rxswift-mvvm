//
//  TabbleViewController.swift
//  Rxswift+mvvm
//
//  Created by zzh on 2024/10/9.
//

import UIKit
import DZNEmptyDataSet
import RxSwift
import RxCocoa
import KafkaRefresh
import SVProgressHUD

class TabbleViewController: BaseViewController, UIScrollViewDelegate{

    let headerRefreshTrigger = PublishSubject<Void>()
    let footerRefreshTrigger = PublishSubject<Void>()

    let isHeaderLoading = BehaviorRelay(value: false)
    let isFooterLoading = BehaviorRelay(value: false)
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: CGRect(), style: .plain)
        view.emptyDataSetSource = self
        view.emptyDataSetDelegate = self
        view.rx.setDelegate(self).disposed(by: rx.disposeBag)
        return view
    }()
    //private lazy var dataSource = TableSectionDataSource(tableView: tableView)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        register()
        tableView.bindGlobalStyle(forHeadRefreshHandler: { [weak self] in
            self?.headerRefreshTrigger.onNext(())
        })
        tableView.bindGlobalStyle(forFootRefreshHandler: { [weak self] in
            self?.footerRefreshTrigger.onNext(())
        })
        
        isHeaderLoading.bind(to: tableView.headRefreshControl.rx.isAnimating).disposed(by: rx.disposeBag)
        isFooterLoading.bind(to: tableView.footRefreshControl.rx.isAnimating).disposed(by: rx.disposeBag)

        tableView.footRefreshControl.autoRefreshOnFoot = false
        
        // Do any additional setup after loading the view.
    }
    override func makeUI() {
        super.makeUI()
        tableView.frame = CGRect(x: 0, y: 130, width: view.frame.size.width, height: view.frame.size.height - 130)
        view.addSubview(tableView)
    }
    func register() {
        
        
    }
    func showData() {
        
        
    }
    override func bindViewModel() {
        super.bindViewModel()
        viewModel?.headerLoading.asObservable().bind(to: isHeaderLoading).disposed(by: rx.disposeBag)
        viewModel?.footerLoading.asObservable().bind(to: isFooterLoading).disposed(by: rx.disposeBag)
        
        isLoading.subscribe(onNext: { [weak self] (_) in
            self?.tableView.reloadEmptyDataSet()
        }).disposed(by: rx.disposeBag)
    }
}
