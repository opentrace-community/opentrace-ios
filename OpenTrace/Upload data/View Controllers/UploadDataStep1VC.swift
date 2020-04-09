//
//  UploadDataStep1VC.swift
//  OpenTrace

import Foundation
import UIKit

class UploadDataStep1VC: UIViewController {
    @IBOutlet weak var verificationCode: UILabel!
    @IBOutlet weak var retryBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let savedVerificationCode = UserDefaults.standard.string(forKey: OTPViewController.userDefaultsPinKey) {
            verificationCode.text = savedVerificationCode
        } else {
            fetchedHandshakePin()
        }
    }

    @IBAction func retryBtnTapped(_ sender: UIButton) {
        fetchedHandshakePin()
    }

    private func fetchedHandshakePin() {
        nextBtn.isEnabled = false
        retryBtn.isHidden = true
        activityIndicator.startAnimating()
        FirebaseAPIs.getHandshakePin { (pin) in
            if let pin = pin {
                self.verificationCode.text = pin
                UserDefaults.standard.set(pin, forKey: OTPViewController.userDefaultsPinKey)
                self.nextBtn.isEnabled = true
            } else {
                self.verificationCode.text = "ERROR"
                self.retryBtn.isHidden = false
            }
            self.activityIndicator.stopAnimating()
        }
    }
}
