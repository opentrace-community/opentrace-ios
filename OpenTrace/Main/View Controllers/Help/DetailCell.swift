//
//  DetailCell.swift
//  OpenTrace
//
//  Created by Robbie Fraser on 15/04/2020.
//  Copyright © 2020 OpenTrace. All rights reserved.
//

import UIKit

extension HelpViewController {

	final class DetailCell: UITableViewCell {

		let identifier = "CustomCellIdentifier"

		var model: HelpViewController.CellModel? {
			didSet {
				titleLabel.text = model?.title
				subTitleLabel.text = model?.subTitle
				if model?.urlString != nil { accessoryType = .disclosureIndicator }
			}
		}

		private let titleLabel: UILabel = {
			let label = UILabel()
			label.textAlignment = .left
			label.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .title1), size: 22)
			label.numberOfLines = 0
			return label
		}()

		private let subTitleLabel : UILabel = {
			let label = UILabel()
			label.textAlignment = .left
			label.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .callout), size: 16)
			label.numberOfLines = 0
			return label
		}()

		override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
			super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
			addSubview(titleLabel)
			addSubview(subTitleLabel)
			titleLabel.translatesAutoresizingMaskIntoConstraints = false
			subTitleLabel.translatesAutoresizingMaskIntoConstraints = false

			NSLayoutConstraint.activate([
				titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
				titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
				titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
			])

			NSLayoutConstraint.activate([
				subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
				subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
				subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
				subTitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
			])
		}

		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}

	}
}
