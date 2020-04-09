//
//  TurnOnBluetoothViewController.swift
//  OpenTrace

import UIKit

class TurnOnBluetoothViewController: UIViewController {

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
    }

}
