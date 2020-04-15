//
//  DropDownTextFIeld.swift
//  OpenTrace
//
//  Created by Robbie Fraser on 15/04/2020.
//  Copyright © 2020 OpenTrace. All rights reserved.
//

import UIKit

final class DropDownTextField: UITextField {

	private let padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 32)

	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setup()
	}

	private func setup() {
		cornerRadius = 8
		backgroundColor = .white
		layer.borderColor = UIColor.black.cgColor
		layer.borderWidth = 2
		setupIconView()
	}

	private func setupIconView() {
		let iconImage = UIImage(named: "ic-back") //TODO: replace with correct asset
		let iconImageView = UIImageView(image: iconImage)
		let container = UIView(frame: .init(x: 0, y: 0, width: 40, height: 30))
		iconImageView.transform = CGAffineTransform(rotationAngle: -.pi/2) //TODO: remove when correct asset is used
		iconImageView.frame = container.frame
		iconImageView.contentMode = .center
		rightViewMode = .always
		container.addSubview(iconImageView)
		rightView = container
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
