//
//  MessageViewController.swift
//  OpenTrace
//
//  Created by Sam Dods on 15/04/2020.
//  Copyright © 2020 OpenTrace. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    @IBOutlet private var finishButton: UIButton!
	@IBOutlet private var headerImage: UIImageView!

	private var titleText: String?
	private var subtitleText: String?
	private var footerButtonText: String?
	private var buttonAction: ((UIViewController) -> Void)?
	private var image: UIImage?

	convenience init() {
        self.init(nibName: String(describing: MessageViewController.self), bundle: Bundle(for: MessageViewController.self))
    }

	func configure(with viewModel: ViewModel, onFooterButtonTap buttonAction: @escaping (UIViewController) -> Void) {
		titleText = viewModel.title
		subtitleText = viewModel.subTitle
		footerButtonText = viewModel.footerButtonTitle
		image = viewModel.image
		self.buttonAction = buttonAction
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		titleLabel.text = titleText
		subtitleLabel.text = subtitleText
		finishButton.setTitle(footerButtonText, for: .normal)
		headerImage.image = image
    }

	@objc private func dismissButtonTapped() {
		dismiss(animated: true)
	}

    @IBAction func didTapFinish(_ sender: Any) {
        buttonAction?(self)
    }
}

extension MessageViewController {

	typealias FeelingWellCopy = DisplayStrings.Monitoring.FeelingWell

	struct ViewModel {
		let image: UIImage?
		let title: String
		let subTitle: String
		let footerButtonTitle: String

		static let feelingGood = ViewModel(image: UIImage(named: "sceneFeelGood"),
										   title: FeelingWellCopy.title,
										   subTitle: FeelingWellCopy.subtitle,
										   footerButtonTitle: FeelingWellCopy.okClose)
	}
}
