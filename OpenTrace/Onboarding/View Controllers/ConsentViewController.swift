//
//  ConsentViewController.swift
//  OpenTrace

import UIKit
import SafariServices

final class ConsentViewController: UIViewController, SFSafariViewControllerDelegate {

	typealias Copy = DisplayStrings.Onboarding.Constent

	@IBOutlet private var headerLabel: UILabel!
	@IBOutlet private var primaryBodyLabel: UILabel!
	@IBOutlet private var secondaryBodyLabel: UILabel!
	@IBOutlet private var preceedingPrivacyButtonLabel: UILabel!
	@IBOutlet private var privacySafeguardButton: UIButton!
	@IBOutlet private var footerButton: UIButton!

	@IBAction func consentBtn(_ sender: UIButton) {
        OnboardingManager.shared.hasConsented = true
    }

    @IBAction func privacySafeguardsBtn(_ sender: Any) {
        guard let url = URL(string: "") else {
            return
        }

        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)

        safariVC.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
		setup()
    }

	private func setup() {
		headerLabel.text = Copy.header
		primaryBodyLabel.text = Copy.primaryBody
		secondaryBodyLabel.text = Copy.secondaryBody
		preceedingPrivacyButtonLabel.text = Copy.preceedingPrivacyButtonTitle
		privacySafeguardButton.setTitle(Copy.privacyButtonTitle, for: .normal)
		footerButton.setTitle(Copy.footerButtonTitle, for: .normal)
	}

    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }

}
