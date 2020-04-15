//
//  StyledButton.swift
//  OpenTrace
//
//  Created by Robbie Fraser on 15/04/2020.
//  Copyright © 2020 OpenTrace. All rights reserved.
//

import UIKit

final class StyledButton: UIButton {

	var appearance: Appearance = .primaryFill {
		didSet {
			setup()
		}
	}

	private var borderLayer = CAShapeLayer()

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
		setupAppearance()
		heightAnchor.constraint(equalToConstant: 56).isActive = true
		titleLabel?.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .headline), size: 16)
	}

	private func setupAppearance() {
		backgroundColor = appearance.backgroundColour
		borderColor = appearance.borderColor
		setTitleColor(appearance.textColour, for: .normal)
		layer.borderColor = appearance.borderColor.cgColor
		layer.borderWidth = 2
	}
}

extension StyledButton {

	struct Appearance {
		let backgroundColour: UIColor
		let borderColor: UIColor
		let textColour: UIColor

		static let primaryFill = Appearance(backgroundColour: .black, borderColor: .clear, textColour: .white)
		static let primaryHollow = Appearance(backgroundColour: .white, borderColor: .black, textColour: .black)
	}
}
