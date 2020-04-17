//
//  UIView+Additions.swift
//  OpenTrace
//
//  Created by Sam Dods on 16/04/2020.
//  Copyright © 2020 OpenTrace. All rights reserved.
//

import UIKit

extension UIView {
    static func loadFromNib() -> Self {
        let nib = UINib(nibName: String(describing: self), bundle: Bundle(for: self))
        return nib.instantiate(withOwner: nil, options: nil).first as! Self
    }
    
     /// Adds subview, sets translatesAutoresizingMaskIntoConstraints to false and calls pin subview to set autolayout constraints.
     /// - Parameter subview: The subview to be added and pinned.
     /// - Parameter edges: UIRect edge mask describing which edges should have constraints added.
     /// - Parameter padding: The amount of padding applied as the constant parameter on the constraint.
     /// - Parameter usingSafeAreaLayoutGuides: The amount of padding applied as the constant parameter on the constraint.
    func addAndPin(subview: UIView,
                           atEdges edges: UIRectEdge = .all,
                           withPadding padding: UIEdgeInsets = .zero,
                           usingSafeAreaLayoutGuides: Bool = false) {
         addSubview(subview)
         subview.translatesAutoresizingMaskIntoConstraints = false
         usingSafeAreaLayoutGuides ? pinToSafeArea(subview: subview, atEdges: edges, withPadding: padding) : pin(subview: subview, atEdges: edges, withPadding: padding)
     }
     
     /// Adds autolayout constraints to subview edges WITHOUT adding it as a subview ot setting translatesAutoresizingMaskIntoConstraints to false
     /// - Parameter subview: The subview to be added and pinned.
     /// - Parameter edges: UIRect edge mask describing which edges should have constraints added.
     /// - Parameter padding: The amount of padding applied as the constant parameter on the constraint.
    func pin(subview: UIView, atEdges edges: UIRectEdge = .all, withPadding padding: UIEdgeInsets = .zero) {
         subview.topAnchor.constraint(equalTo: topAnchor, constant: padding.top).isActive = edges.contains(.top)
         subview.leftAnchor.constraint(equalTo: leftAnchor, constant: padding.left).isActive = edges.contains(.left)
         subview.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding.right).isActive = edges.contains(.right)
         subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding.bottom).isActive = edges.contains(.bottom)
     }
     
     /// Adds autolayout constraints to subview safe area layour gutide WITHOUT adding it as a subview ot setting translatesAutoresizingMaskIntoConstraints to false
     /// - Parameter subview: The subview to be added and pinned.
     /// - Parameter edges: UIRect edge mask describing which edges should have constraints added.
     /// - Parameter padding: The amount of padding applied as the constant parameter on the constraint.
    func pinToSafeArea(subview: UIView, atEdges edges: UIRectEdge = .all, withPadding padding: UIEdgeInsets = .zero) {
         subview.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding.top).isActive = edges.contains(.top)
         subview.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: padding.left).isActive = edges.contains(.left)
         subview.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -padding.right).isActive = edges.contains(.right)
         subview.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding.bottom).isActive = edges.contains(.bottom)
     }
}
