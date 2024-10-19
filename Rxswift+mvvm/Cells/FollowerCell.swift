//
//  ButtonnCell.swift
//  GHDemo
//
//  Created by zzh on 2024/10/6.
//

import UIKit
import RxSwift

class FollowerCell: BaseTableViewCell,TableRowCell {
    var item: FollowerItem?
    typealias Item = FollowerItem
    
    let bt = UIButton(type: .custom)
    let sw = UISwitch()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    func setup(with rowModel: FollowerItem) {
        item = rowModel
        bt.setTitle(rowModel.follower?.login, for: .normal)
        bt.setTitleColor(.red, for: .normal)
        bt.backgroundColor = .cyan
        bt.rx.controlEvent(.touchUpInside)
            .map({ _ in
                return rowModel
            })
            .bind(to: rowModel.elements!.asObserver())
            .disposed(by: disposeBag)
//        rowModel.change!.asObservable()
//                    .bind(to: sw.rx.isOn)
//                    .disposed(by: disposeBag)
//        sw.rx.isOn.bind(to: rowModel.change!).disposed(by: disposeBag)
        
        (sw.rx.isOn <-> rowModel.change!).disposed(by: disposeBag)
       
    }
    override func setupSubViews() {
        contentView.addSubview(bt)
        bt.frame = CGRect(x: 20, y: 10, width: 100, height: 30)
        contentView.addSubview(sw)
        sw.frame = CGRect(x: 130, y: 10, width: 40, height: 30)
    }
//    override func setup(with rowModel: any TableRowModel) {
//        let viewModel = rowModel as! FollowerItem
//        item = viewModel
//        bt.setTitle(viewModel.follower?.login, for: .normal)
//        bt.setTitleColor(.red, for: .normal)
//        bt.backgroundColor = .cyan
//        bt.rx.controlEvent(.touchUpInside)
//            .map({ _ in
//                return viewModel
//            })
//            .bind(to: viewModel.elements!.asObserver())
//            .disposed(by: disposeBag)
//        viewModel.change!.asObservable()
//                    .bind(to: sw.rx.isOn)
//                    .disposed(by: disposeBag)
//        sw.rx.isOn.bind(to: viewModel.change!).disposed(by: disposeBag)
//    }
    
    
//    func bind(to viewModel: FollowerItem) {
//        item = viewModel
//        bt.setTitle(viewModel.follower?.login, for: .normal)
//        bt.setTitleColor(.red, for: .normal)
//        bt.backgroundColor = .cyan
//        bt.rx.controlEvent(.touchUpInside)
//            .map({ _ in
//                return viewModel
//            })
//            .bind(to: viewModel.elements!.asObserver())
//            .disposed(by: disposeBag)
//        viewModel.change!.asObservable()
//                    .bind(to: sw.rx.isOn)
//                    .disposed(by: disposeBag)
//        sw.rx.isOn.bind(to: viewModel.change!).disposed(by: disposeBag)
//       
//    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    deinit{
        print("deinit")
    }

}
