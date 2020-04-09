//
//  PhoneNumberViewController.swift
//  OpenTrace

import UIKit
import FirebaseAuth

class PhoneNumberViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var getOTPButton: UIButton!
    let MIN_PHONE_LENGTH = 8
    let PHONE_NUMBER_LENGTH = 15
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.phoneNumberField.addTarget(self, action: #selector(self.phoneNumberFieldDidChange), for: UIControl.Event.editingChanged)
        self.phoneNumberFieldDidChange()
        phoneNumberField.delegate = self
        dismissKeyboardOnTap()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.phoneNumberField.becomeFirstResponder()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @IBAction func nextButtonClicked(_ sender: Any) {
        getOTPButton.isEnabled = false
        verifyPhoneNumberAndProceed(self.phoneNumberField.text ?? "")
    }

    @objc
    func phoneNumberFieldDidChange() {
        self.getOTPButton.isEnabled = self.phoneNumberField.text?.count ?? 0 >= MIN_PHONE_LENGTH
        if self.phoneNumberField.text?.count == PHONE_NUMBER_LENGTH {
            self.phoneNumberField.resignFirstResponder()
        }
    }

    func verifyPhoneNumberAndProceed(_ mobileNumber: String) {
        activityIndicator.startAnimating()
        PhoneAuthProvider.provider().verifyPhoneNumber(mobileNumber, uiDelegate: nil) { [weak self] (verificationID, error) in
            if let error = error {
                let errorAlert = UIAlertController(title: "Error verifying phone number", message: error.localizedDescription, preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("Unable to verify phone number")
                }))
                self?.present(errorAlert, animated: true)
                Logger.DLog("Phone number verification error: \(error.localizedDescription)")
                return
            }
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            UserDefaults.standard.set(mobileNumber, forKey: "mobileNumber")
            self?.performSegue(withIdentifier: "segueFromNumberToOTP", sender: self)
            self?.activityIndicator.stopAnimating()
        }
    }

    //  limit text field input to 15 characters
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                           replacementString string: String) -> Bool {
        let maxLength = PHONE_NUMBER_LENGTH
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
}
