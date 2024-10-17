//
//  TabbleViewUnitil.swift
//  Rxswift+mvvm
//
//  Created by zzh on 2024/10/9.
//

import Foundation
import UIKit

public final class TableSectionDataSource : NSObject ,UITableViewDataSource,UITableViewDelegate {
    
    private weak var tableView: UITableView?
    private var items: [TableSection] = []
    
    init(items: [TableSection] = [], tableView: UITableView) {
        super.init()
        self.items = items
        self.tableView = tableView
        self.tableView?.dataSource = self
        self.tableView?.delegate = self

    }
    
    func update(with items: [TableSection]) {
        self.items = items
        self.tableView?.reloadData()
    }
    public func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].rowModels.count
    }
    
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let tableSection = items[section]
        if let item = tableSection.headerModel {
            guard let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: item.reuseID) else {
                item.register(in: tableView)
                return self.tableView(tableView, viewForHeaderInSection: section)
            }
            item.render(in: cell)
            return cell
        }
        return nil
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 40
     }

    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableSection = items[indexPath.section]
        let item = tableSection.rowModels[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: item.reuseID) else {
            item.register(in: tableView)

            return self.tableView(tableView, cellForRowAt: indexPath)
        }
        item.render(in: cell)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    
    
}
