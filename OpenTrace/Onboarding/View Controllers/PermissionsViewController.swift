//
//  PermissionsViewController.swift
//  OpenTrace

import UIKit
import UserNotifications

final class PermissionsViewController: UIViewController {

	private typealias Copy = DisplayStrings.Onboarding.Permissions
	
	@IBOutlet private var headerLabel: UILabel!
	@IBOutlet private var primaryBodyLabel: UILabel!
	@IBOutlet private var secondaryBodyLabel: UILabel!
	@IBOutlet private var tertiaryBodyLabel: UILabel!
	@IBOutlet private var footerButton: UIButton!

	@IBAction func allowPermissionsBtn(_ sender: UIButton) {
        BluetraceManager.shared.turnOn()
        OnboardingManager.shared.allowedPermissions = true
        registerForPushNotifications()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
		setup()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
    }

	private func setup() {
		headerLabel.text = Copy.header
		primaryBodyLabel.text = Copy.primaryBody
		secondaryBodyLabel.text = Copy.secondaryBody
		tertiaryBodyLabel.text = Copy.tertiaryBody
		footerButton.setTitle(Copy.footerButtonTitle, for: .normal)
	}

    func registerForPushNotifications() {
        BlueTraceLocalNotifications.shared.checkAuthorization { (_) in
            //Make updates to VCs if any here.
        }
    }

}
