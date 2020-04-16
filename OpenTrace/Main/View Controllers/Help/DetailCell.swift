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
				if model?.urlString != nil {
					let image = UIImage(named: "discIndicator")
					let indicatorImageView = UIImageView(image: image)
					accessoryView = indicatorImageView
				}
			}
		}

		private let titleLabel: UILabel = {
			let label = UILabel()
			label.textAlignment = .left
			label.font = UIFont.monospacedDigitSystemFont(ofSize: 18, weight: .bold)
			label.numberOfLines = 0
			return label
		}()

		private let subTitleLabel : UILabel = {
			let label = UILabel()
			label.textAlignment = .left
			label.font = UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .regular)
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
				titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
				titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 21),
				titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -76)
			])

			NSLayoutConstraint.activate([
				subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
				subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -76),
				subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 21),
				subTitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24)
			])
		}

		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}

		override func prepareForReuse() {
			super.prepareForReuse()
			accessoryView = nil
			titleLabel.text = ""
			subTitleLabel.text = ""
			isSelected = false
		}

	}
}
