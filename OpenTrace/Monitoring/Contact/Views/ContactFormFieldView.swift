//
//  ContactFormFieldView.swift
//  OpenTrace
//
//  Created by Sam Dods on 16/04/2020.
//  Copyright © 2020 OpenTrace. All rights reserved.
//

import UIKit

class ContactFormFieldView: UIView {
    
    @IBOutlet private var textField: StyledTextField!
    
    static func with(placeholder: String) -> Self {
        let view = loadFromNib()
        view.configure(placeholder: placeholder)
        return view
    }
    
    func configure(placeholder: String) {
        textField.placeholder = placeholder
    }
}
