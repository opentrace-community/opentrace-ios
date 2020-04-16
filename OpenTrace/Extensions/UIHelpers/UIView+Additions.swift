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
}
