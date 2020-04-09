//
//  ConsentViewController.swift
//  OpenTrace

import UIKit
import SafariServices

class ConsentViewController: UIViewController, SFSafariViewControllerDelegate {

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
    }

    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }

}
