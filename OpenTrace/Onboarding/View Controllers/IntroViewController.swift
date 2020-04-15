//
//  IntroViewController.swift
//  OpenTrace

import UIKit
import FirebaseAuth

final class IntroViewController: UIViewController {

	private typealias Copy = DisplayStrings.Onboarding.Intro

	@IBOutlet private var headerLabel: UILabel!
	@IBOutlet private var primaryBodyLabel: UILabel!
	@IBOutlet private var secondaryBodyLabel: UILabel!
	@IBOutlet private var footerButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
		setup()
    }

	private func setup() {
		headerLabel.text = Copy.header
		primaryBodyLabel.text = Copy.primaryBody
		secondaryBodyLabel.text = Copy.secondaryBody
		footerButton.setTitle(Copy.footerButtonTitle, for: .normal)
	}

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
