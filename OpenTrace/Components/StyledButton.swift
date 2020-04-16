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

	override var isSelected: Bool {
		didSet {
			if appearance.isRadioButton {
				backgroundColor = isSelected ? appearance.textColour : appearance.backgroundColour
			}
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
		tintColor = .clear
	}

	private func setupAppearance() {
		backgroundColor = appearance.backgroundColour
		layer.borderColor = appearance.borderColour.cgColor
		layer.borderWidth = 2
		setTitleColor(appearance.textColour, for: .normal)
		setTitleColor(appearance.backgroundColour, for: [.selected, .highlighted])
	}
}

extension StyledButton {

	struct Appearance {
		let backgroundColour: UIColor
		let borderColour: UIColor
		let textColour: UIColor
		let isRadioButton: Bool

		static let primaryFill = Appearance(backgroundColour: .black, borderColour: .black, textColour: .white, isRadioButton: false)
		static let primaryHollow = Appearance(backgroundColour: .white, borderColour: .black, textColour: .black, isRadioButton: false)
		static let primaryHollowRadio = Appearance(backgroundColour: .white, borderColour: .black, textColour: .black, isRadioButton: true)
	}
}
