//
//  SectionHeaderCell.swift
//  OpenTrace
//
//  Created by Robbie Fraser on 16/04/2020.
//  Copyright © 2020 OpenTrace. All rights reserved.
//

import UIKit

extension HelpViewController {

	final class SectionHeaderView: UIView {

		let label = UILabel()

		var title: String? {
			didSet {
				label.text = title
			}
		}

		override init(frame: CGRect) {
			super.init(frame: frame)
			setup()
		}

		required init?(coder: NSCoder) {
			super.init(coder: coder)
			setup()
		}

		private func setup() {
			backgroundColor = .black
			label.textColor = .white
			label.font = UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .bold)
			addSubview(label)
			label.translatesAutoresizingMaskIntoConstraints = false
			NSLayoutConstraint.activate([
				label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
				label.topAnchor.constraint(equalTo: topAnchor, constant: 7),
				label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
				label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7),
			])
		}
	}

}
