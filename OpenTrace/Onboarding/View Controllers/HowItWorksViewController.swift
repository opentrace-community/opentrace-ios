//
//  HowItWorksViewController.swift
//  OpenTrace

import UIKit
import FirebaseAuth

class HowItWorksViewController: UIViewController {

    @IBAction func greatBtnOnClick(_ sender: UIButton) {

        OnboardingManager.shared.completedIWantToHelp = true
        self.performSegue(withIdentifier: "iWantToHelpToConsentSegue", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

}
