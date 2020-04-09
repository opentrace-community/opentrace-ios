//
//  PermissionsViewController.swift
//  OpenTrace

import UIKit
import UserNotifications

class PermissionsViewController: UIViewController {

    @IBAction func allowPermissionsBtn(_ sender: UIButton) {
        BluetraceManager.shared.turnOn()
        OnboardingManager.shared.allowedPermissions = true
        registerForPushNotifications()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers

    }

    func registerForPushNotifications() {
        BlueTraceLocalNotifications.shared.checkAuthorization { (_) in
            //Make updates to VCs if any here.
        }
    }

}
