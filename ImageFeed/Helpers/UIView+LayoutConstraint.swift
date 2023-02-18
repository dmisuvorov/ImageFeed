//
//  UIView+LayoutConstraint.swift
//  ImageFeed
//
//  Created by Суворов Дмитрий Владимирович on 23.01.2023.
//

import UIKit

typealias Constraint = (_ child: UIView, _ parent: UIView) -> NSLayoutConstraint

func equal<Anchor, Axis>(_ keyPath: KeyPath<UIView, Anchor>, to constant: CGFloat = 0) -> Constraint where Anchor: NSLayoutAnchor<Axis> {
    return { view, parent in
        view[keyPath: keyPath].constraint(equalTo: parent[keyPath: keyPath], constant: constant)
    }
}

func equal<Anchor>(_ keyPath: KeyPath<UIView, Anchor>, to constant: CGFloat = 0) -> Constraint where Anchor: NSLayoutDimension {
    return { view, parent in
        view[keyPath: keyPath].constraint(equalToConstant: constant)
    }
}

func equal<Anchor, Axis>(_ from: KeyPath<UIView, Anchor>, _ to: KeyPath<UIView, Anchor>, to constant: CGFloat = 0) -> Constraint where Anchor: NSLayoutAnchor<Axis> {
    return { view, parent in
        view[keyPath: from].constraint(equalTo: parent[keyPath: to], constant: constant)
    }
}

func equal<Anchor, Axis>(_ from: KeyPath<UIView, Anchor>, _ to: Anchor, to constant: CGFloat = 0) -> Constraint where Anchor: NSLayoutAnchor<Axis> {
    return { view, _ in
        view[keyPath: from].constraint(equalTo: to, constant: constant)
    }
}

extension UIView {

    func addSubview(_ subview: UIView, constraints: [Constraint]) {
        self.addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints.map { constraint in
            return constraint(subview, self)
        })
    }
}
