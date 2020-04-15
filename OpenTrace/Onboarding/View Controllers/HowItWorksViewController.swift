//
//  HowItWorksViewController.swift
//  OpenTrace

import UIKit
import FirebaseAuth

final class HowItWorksViewController: UIViewController {

	private typealias Copy = DisplayStrings.Onboarding.HowItWorks

	@IBOutlet private var headerLabel: UILabel!
	@IBOutlet private var bodyLabel: UILabel!
	@IBOutlet private var greatBtn: UIButton!

	@IBAction func greatBtnOnClick(_ sender: UIButton) {

        OnboardingManager.shared.completedIWantToHelp = true
        self.performSegue(withIdentifier: "iWantToHelpToConsentSegue", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
		setup()
    }

	private func setup() {
		headerLabel.text = Copy.header
		bodyLabel.text = Copy.body
		greatBtn.setTitle(Copy.footerButtonTitle, for: .normal)
	}

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

}
