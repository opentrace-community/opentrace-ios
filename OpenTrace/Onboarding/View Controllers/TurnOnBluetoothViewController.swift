//
//  TurnOnBluetoothViewController.swift
//  OpenTrace

import UIKit

final class TurnOnBluetoothViewController: UIViewController {

	private typealias Copy = DisplayStrings.Onboarding.TurnOnBluetooth

	@IBOutlet var headerLabel: UILabel!
	@IBOutlet var primaryBodyLabel: UILabel!
	@IBOutlet var secondaryBodyLabel: UILabel!
	@IBOutlet var footerButton: UIButton!

	@IBAction func enabledBluetoothBtn(_ sender: UIButton) {

        OnboardingManager.shared.completedBluetoothOnboarding = true

        let blePoweredOn = BluetraceManager.shared.isBluetoothOn()
        let bleAuthorized = BluetraceManager.shared.isBluetoothAuthorized()

        BlueTraceLocalNotifications.shared.checkAuthorization { (granted) in
            if granted && blePoweredOn && bleAuthorized {
                self.performSegue(withIdentifier: "showFullySetUpFromTurnOnBtSegue", sender: self)
            } else {
                self.performSegue(withIdentifier: "showHomeFromTurnOnBtSegue", sender: self)
            }
        }
    }

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

}
