//
//  ContactFormFieldView.swift
//  OpenTrace
//
//  Created by Sam Dods on 16/04/2020.
//  Copyright © 2020 OpenTrace. All rights reserved.
//

import UIKit

class ContactFormFieldView: UIView, UITextFieldDelegate {
    
    @IBOutlet private var textField: StyledTextField!
    weak var nextField: ContactFormFieldView? {
        didSet {
            textField.returnKeyType = .next
        }
    }
    
    var inputValue: String {
        return textField.text ?? ""
    }
    
    static func with(placeholder: String) -> Self {
        let view = loadFromNib()
        view.configure(placeholder: placeholder)
        return view
    }
    
    func configure(placeholder: String) {
        textField.placeholder = placeholder
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = nextField {
            return nextField.becomeFirstResponder()
        } else {
            return resignFirstResponder()
        }
    }
    
    // MARK: - Responder chain
    
    override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        return textField.resignFirstResponder()
    }
    
    override var isFirstResponder: Bool {
        return textField.isFirstResponder
    }
}
