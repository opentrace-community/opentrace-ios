//
//  TableHeaderView.swift
//  OpenTrace
//
//  Created by Robbie Fraser on 16/04/2020.
//  Copyright © 2020 OpenTrace. All rights reserved.
//

import UIKit

final class TableHeaderView: UIView {

	private typealias Copy = DisplayStrings.Help.Header

	private let imageView = UIImageView()
	private let titleLabel = UILabel()
	private let subtitleLabel = UILabel()

	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setup()
	}

	private func setup() {
		[imageView, titleLabel, subtitleLabel].forEach { view in
			addSubview(view)
			view.translatesAutoresizingMaskIntoConstraints = false
		}

		titleLabel.text = Copy.title
		titleLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 24, weight: .bold)
		titleLabel.numberOfLines = 0
		subtitleLabel.text = Copy.subtitle
		subtitleLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .regular)
		subtitleLabel.numberOfLines = 0
		imageView.image = UIImage(named: "sceneHelp")

		NSLayoutConstraint.activate([
			imageView.topAnchor.constraint(equalTo: topAnchor, constant: 25),
			imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 44),
			imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -44),
			imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 207/285),

			titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 37),
			titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 22),
			titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -22),

			subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 19),
			subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 22),
			subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -22),
			subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
		])
	}
}
