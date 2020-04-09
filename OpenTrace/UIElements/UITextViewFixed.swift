//
//  UITextViewFixed.swift
//  OpenTrace

import UIKit

@IBDesignable
class UITextViewFixed: UITextView {

    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }

    func setup() {
        textContainerInset = UIEdgeInsets.zero
        textContainer.lineFragmentPadding = 0
    }

}
