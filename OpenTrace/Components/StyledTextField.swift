//
//  StyledTextField.swift
//  OpenTrace
//
//  Created by Robbie Fraser on 16/04/2020.
//  Copyright © 2020 OpenTrace. All rights reserved.
//

import UIKit

final class StyledTextField: UITextField {

	private let padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setup()
	}

	private func setup() {
		backgroundColor = .white
		layer.borderColor = UIColor.black.cgColor
		layer.borderWidth = 1
		textColor = .black
		attributedPlaceholder = NSAttributedString(string: placeholder ?? "",
												   attributes: [NSAttributedString.Key.foregroundColor: UIColor.black,
																NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
	}
    
    override var placeholder: String? {
        didSet {
            attributedPlaceholder = NSAttributedString(string: placeholder ?? "",
                                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor.black,
                                                                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
        }
    }

	override func textRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.inset(by: padding)
	}

	override func editingRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.inset(by: padding)
	}

	override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.inset(by: padding)
	}

}
