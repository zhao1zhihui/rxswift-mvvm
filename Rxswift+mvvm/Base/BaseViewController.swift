//
//  BaseViewController.swift
//  Rxswift+mvvm
//
//  Created by zzh on 2024/10/9.
//

import UIKit
import DZNEmptyDataSet
import SVProgressHUD
import RxSwift
import RxCocoa
import Moya
import Toast_Swift



class BaseViewController: UIViewController {
    
    var viewModel: ViewModel?

    // 空集合设置
    let emptyDataSetButtonTap = PublishSubject<Void>()
    var emptyDataSetTitle = "暂无数据"
    var emptyDataSetDescription = "请重新尝试"
    var emptyDataSetImage = UIImage(systemName: "questionmark.folder")
    var emptyDataSetImageTintColor = BehaviorRelay<UIColor?>(value: UIColor.red)
    
    // 加载框loding
    let isLoading = BehaviorRelay(value: true)
    // 加载失败error
    let error = PublishSubject<Error>()
    // 加载失败error
    let resultError = PublishSubject<Error>()

    // 设置title
    var navigationTitle = "" {
        didSet {
            navigationItem.title = navigationTitle
        }
    }
    // 设置baritem 空隙
    let spaceBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
    // 返回按钮button
    lazy var closeBarButton: UIBarButtonItem = {
        let view = UIBarButtonItem(image: UIImage(systemName:"arrow.left"),
                                 style: .plain,
                                 target: self,
                                 action: nil)
        return view
    }()
    // contentView
    lazy var contentView: UIView = {
        let view = UIView()
        self.view.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        return view
    }()
    // stackView
    lazy var stackView: UIStackView = {
        let subviews: [UIView] = []
        let view = UIStackView(arrangedSubviews: subviews)
        view.spacing = 0
        self.contentView.addSubview(view)
        view.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        bindViewModel()
        closeBarButton.rx.tap.asObservable().subscribe(onNext: { [weak self] () in
            self?.navigationController?.dismiss(animated: true)
        }).disposed(by: rx.disposeBag)
    }
    func makeUI() {
        navigationItem.backBarButtonItem = closeBarButton
        navigationItem.title = navigationTitle
    }
    func bindViewModel() {
        
        // 忽略第一个值因为他是没有绑定流为0 翻出false错误信号
        viewModel?.loading.skip(1).asObservable()
            .subscribe(onNext: { Lodinng in
                print("\(Lodinng)")
                self.isLoading.accept(Lodinng)
            }).disposed(by: rx.disposeBag)
        viewModel?.error.asObservable().bind(to: error).disposed(by: rx.disposeBag)
        viewModel?.resultError.asObservable().bind(to: resultError).disposed(by: rx.disposeBag)

        
        error.subscribe(onNext: { [weak self] (error) in
            self?.view.makeToast(error.localizedDescription, title: "提示", image: UIImage(systemName: "exclamationmark.triangle"))
        }).disposed(by: rx.disposeBag)
        
        resultError.subscribe(onNext: { [weak self] (error) in
            self?.view.makeToast(error.localizedDescription, title: "提示", image: UIImage(systemName: "exclamationmark.triangle"))
        }).disposed(by: rx.disposeBag)
        
//        isLoading.subscribe(onNext: { isLoading in
//            UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
//        }).disposed(by: rx.disposeBag)
    }

}

extension BaseViewController: DZNEmptyDataSetSource {

    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: emptyDataSetTitle)
    }

    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: emptyDataSetDescription)
    }

    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return emptyDataSetImage
    }

    func imageTintColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return emptyDataSetImageTintColor.value
    }

    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return .clear
    }

    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return -60
    }
}

extension BaseViewController: DZNEmptyDataSetDelegate {

    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return !isLoading.value
    }

    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }

    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        emptyDataSetButtonTap.onNext(())
    }
}

