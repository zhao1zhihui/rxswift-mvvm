//
//  BaseTableViewCell.swift
//  Rxswift+mvvm
//
//  Created by zzh on 2024/10/9.
//

import UIKit
import RxSwift



class BaseTableViewCell: UITableViewCell {

    public var disposeBag: DisposeBag = DisposeBag()
    override func prepareForReuse() {
         super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupSubViews()
    }
    func setupSubViews() {
        
    }
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

}
