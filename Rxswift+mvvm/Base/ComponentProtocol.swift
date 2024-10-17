//
//  ComponentProtocol.swift
//  Rxswift+mvvm
//
//  Created by zzh on 2024/10/9.
//

import Foundation
import UIKit
import RxDataSources


// cell protocol
protocol TableRowCell {
    associatedtype Item: NSObject
    var item: Item? { get }
    func setup(with rowModel: Item)
}
// model protocol
protocol TableRowModel {
    associatedtype Cell: UITableViewCell
    var reuseID: String { get }
    func register(in tableView: UITableView)
    func render(in cell: Cell)
}

extension TableRowModel {
  // default implementation
    var reuseID: String {
        return String(reflecting: Cell.self)
    }
}
extension TableRowModel {
    func register(in tableView: UITableView){
        tableView.register(Cell.self, forCellReuseIdentifier: reuseID)
    }
}
extension TableRowModel {
    var anyTableRowModel: AnyTableRowModel{
        return AnyTableRowModel(self)
    }
}

final class AnyTableRowModel {
    private let _register : (UITableView) -> Void
    private let _render: (UITableViewCell) -> Void
    let reuseID: String
    
    init<Base: TableRowModel>(_ base: Base) {
        self.reuseID = base.reuseID
        self._register = base.register
        self._render = { cell in
            guard let cell = cell as? Base.Cell else {
                assertionFailure("Type missmatch")
                return
            }
            base.render(in: cell)
        }
    }
    func register(in tableView:UITableView){
        _register(tableView)
    }
    func render(in cell : UITableViewCell){
        _render(cell)
    }
}

// modelTableHeader protocol
protocol TableHeaderFooterModel {
    associatedtype Cell: UITableViewHeaderFooterView

    var reuseID: String { get }

    func register(in tableView: UITableView)
    func render(in cell: Cell)
}

extension TableHeaderFooterModel {
  // default implementation
    var reuseID: String {
        return String(reflecting: Cell.self)
    }
}
extension TableHeaderFooterModel {
    func register(in tableView: UITableView){
        tableView.register(Cell.self, forHeaderFooterViewReuseIdentifier: reuseID)
    }
}
extension TableHeaderFooterModel {
    var anyTableHeaderFooterModel: AnyTableHeaderFooterModel{
        return AnyTableHeaderFooterModel(self)
    }
}

final class AnyTableHeaderFooterModel {
    private let _register : (UITableView) -> Void
    private let _render: (UITableViewHeaderFooterView) -> Void
    let reuseID: String
    
    init<Base: TableHeaderFooterModel>(_ base: Base) {
        self.reuseID = base.reuseID
        self._register = base.register
        self._render = { cell in
            guard let cell = cell as? Base.Cell else {
                assertionFailure("Type missmatch")
                return
            }
            base.render(in: cell)
        }
    }
    func register(in tableView:UITableView){
        _register(tableView)
    }
    func render(in cell : UITableViewHeaderFooterView){
        _render(cell)
    }
}
// section cell HeaderFooterView
final class TableSection{
    public var headerModel: AnyTableHeaderFooterModel?
    public var rowModels: [AnyTableRowModel] = []
    public var footerModel: AnyTableHeaderFooterModel?
    init(headerModel: AnyTableHeaderFooterModel? = nil, rowModels: [AnyTableRowModel], footerModel: AnyTableHeaderFooterModel? = nil) {
        self.headerModel = headerModel
        self.rowModels = rowModels
        self.footerModel = footerModel
    }
}
// section  cell  title
final class TableSectionTitle : SectionModelType {
    var title: String = ""
    init(original: TableSectionTitle, items: [AnyTableRowModel]) {
        self.items = items
    }
    init(title:String ,items: [AnyTableRowModel]){
        self.title = title
        self.items = items
    }
    typealias Item = AnyTableRowModel
    var items: [AnyTableRowModel]
}


