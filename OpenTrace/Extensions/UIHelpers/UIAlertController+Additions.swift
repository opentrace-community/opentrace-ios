//
//  UIAlertController+Additions.swift
//  OpenTrace
//
//  Created by Neil Horton on 15/04/2020.
//  Copyright © 2020 OpenTrace. All rights reserved.
//

import UIKit

extension UIAlertController {
    static func buildGenericAlert() -> UIAlertController {
        let alert = UIAlertController(title: DisplayStrings.Gloabl.GenericError.title,
                                      message: DisplayStrings.Gloabl.GenericError.body,
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: DisplayStrings.Gloabl.GenericError.dismissAction,
                                      style: .default,
                                      handler: nil))
        return alert
    }
}
