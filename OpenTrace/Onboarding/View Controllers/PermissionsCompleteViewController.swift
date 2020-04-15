//
//  PermissionsCompleteViewController.swift
//  OpenTrace

import UIKit

final class PermissionsCompleteViewController: UIViewController {

	private typealias Copy = DisplayStrings.Onboarding.PermissionsComplete

	@IBOutlet private var headerLabel: UILabel!
	@IBOutlet private var bodyLabel: UILabel!
	@IBOutlet private var footerButton: UIButton!

	override func viewDidLoad() {
        super.viewDidLoad()
		setup()
    }

	private func setup() {
		headerLabel.text = Copy.header
		bodyLabel.text = Copy.body
		footerButton.setTitle(Copy.footerButtonTitle, for: .normal)
	}
}
