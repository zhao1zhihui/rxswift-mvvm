//
//  BaseHeaderFooterView.swift
//  Rxswift+mvvm
//
//  Created by zzh on 2024/10/9.
//

import UIKit

class BaseHeaderFooterView: UITableViewHeaderFooterView {

    
    override init(reuseIdentifier: String?) {
            super.init(reuseIdentifier: reuseIdentifier)
            setupSubviews()
    }
    open func setup(with headerFooterModel: AnyTableHeaderFooterModel) {
        fatalError("Method must be overriden")
    }

    open func setupSubviews() {
        fatalError("Method must be overriden")
    }
        
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
        
        
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

