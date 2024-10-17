//
//  TabbleViewHeaderFooterView+Rx.swift
//  Rxswift+mvvm
//
//  Created by zzh on 2024/10/9.
//
import UIKit
import RxCocoa
import RxSwift
extension Reactive where Base: UITableView {
    func viewForHeaderInSection<Sequence: Swift.Sequence, View: UITableViewHeaderFooterView, Source: ObservableType>()
    -> (_ source: Source)
    -> (_ configure: @escaping (UITableView, Int, Sequence.Element) -> View)
    -> Disposable
    where Source.Element == Sequence {
        { source in
            { builder in
                let delegate = RxTableViewDelegate<Sequence, View>(builder: builder)
                base.rx.delegate.setForwardToDelegate(delegate, retainDelegate: false)
                return source
                    .concat(Observable.never())
                    .subscribe(onNext: { [weak base] elements in
                        delegate.pushElements(elements)
                        base?.reloadData()
                    })
            }
        }
    }
}

final class RxTableViewDelegate<Sequence, View: UITableViewHeaderFooterView>: NSObject, UITableViewDelegate where Sequence: Swift.Sequence {
    let build: (UITableView, Int, Sequence.Element) -> View
    private var elements: [Sequence.Element] = []

    init(builder: @escaping (UITableView ,Int, Sequence.Element) -> View) {
        self.build = builder
    }

    func pushElements(_ elements: Sequence) {
        self.elements = Array(elements)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return build(tableView ,section, elements[section])
    }
}
