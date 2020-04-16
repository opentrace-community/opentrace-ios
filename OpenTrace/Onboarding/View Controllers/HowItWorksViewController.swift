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
        #warning("TODO:- Show loading here when we have a decent loading UI")
        Auth.auth().signInAnonymously { [weak self] (result, error) in
//            if error != nil || result == nil {
//                self?.showError()
//                return
//            }
            self?.performSegue(withIdentifier: "iWantToHelpToConsentSegue", sender: self)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func showError() {
        let alert = UIAlertController.buildGenericAlert()
        present(alert, animated: true, completion: nil) 
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
