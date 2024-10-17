//
//  FollowerLisrVC.swift
//  GHDemo
//
//  Created by zzh on 2024/10/5.
//

import UIKit
import RxCocoa
import RxSwift
import NSObject_Rx
import RxDataSources

class FollowerLisrVC: TabbleViewController {

    var username:String?
    var disposeBag: DisposeBag = DisposeBag()
    
    override func register() {
        self.tableView.register(FollowerCell.self, forCellReuseIdentifier: String(reflecting: FollowerCell.self))
        self.tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "cell")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let followerListVM:FollowerListVM = viewModel as! FollowerListVM
        view.backgroundColor = .systemBackground
        let search = UISearchTextField(frame: CGRect(x: 0, y: 100, width: view.frame.size.width, height: 30))
        search.text = username!
        view.addSubview(search)
        let input = FollowerListVM.Input(search: search.rx.text.orEmpty.debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance).asObservable(), headerRefresh:headerRefreshTrigger , footerRefresh: footerRefreshTrigger )
        let output =  followerListVM.transform(input:input);
        // Do any additional setup after loading the view.
        
        let dataSource = RxTableViewSectionedReloadDataSource<TableSectionTitle>(configureCell: { dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: item.reuseID, for:indexPath)
            item.render(in: cell)
            return cell
        })
        output.items
            .bind(to: tableView.rx.viewForHeaderInSection()){tableView, section, item in
                let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "cell")
                cell?.textLabel?.text = item.title
                return cell ?? UITableViewHeaderFooterView()
            }
            .disposed(by: disposeBag)
        
        output.items.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)
        // 最简单版本 直接专门cell 调用方法
//        output.items.asDriver(onErrorJustReturn: [])
//            .drive(tableView.rx.items(cellIdentifier: "cell", cellType: FollowerCell.self)) { tableView, viewModel, cell in
//                cell.bind(to: viewModel)
//            }.disposed(by: disposeBag)
    }
    deinit{
        print("deinit")
    }
}
