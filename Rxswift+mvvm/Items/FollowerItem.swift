//
//  btITEM.swift
//  GHDemo
//
//  Created by zzh on 2024/10/6.
//

import UIKit
import RxSwift
import RxRelay

class FollowerItem: NSObject, TableRowModel {    
    typealias Cell = FollowerCell
    var elements:PublishSubject<FollowerItem>?
    var change:BehaviorRelay<Bool>?
    var follower:Follower?
    func render(in cell: FollowerCell) {
        cell.setup(with: self)
    }
}
