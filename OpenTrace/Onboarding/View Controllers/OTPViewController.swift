//
//  OTPViewController.swift
//  OpenTrace

import UIKit
import FirebaseAuth
import FirebaseFunctions

class OTPViewController: UIViewController {

    enum Status {
        case InvalidOTP
        case WrongOTP
        case Success
    }

    // MARK: - UI

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var codeInputView: CodeInputView?
    @IBOutlet weak var expiredMessageLabel: UILabel?
    @IBOutlet weak var errorMessageLabel: UILabel?

    @IBOutlet weak var wrongNumberButton: UIButton?
    @IBOutlet weak var resendCodeButton: UIButton?

    @IBOutlet weak var verifyButton: UIButton?

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var timer: Timer?

    static let twoMinutes = 120
    static let userDefaultsPinKey = "HEALTH_AUTH_VERIFICATION_CODE"

    var countdownSeconds = twoMinutes
    lazy var functions = Functions.functions(region: PlistHelper.getvalueFromInfoPlist(withKey: "CLOUDFUNCTIONS_REGION") ?? "asia-east2")

    let linkButtonAttributes: [NSAttributedString.Key: Any] = [.font: UIFont(name: "Muli", size: 16)!, .foregroundColor: UIColor.blue, .underlineStyle: NSUnderlineStyle.single.rawValue]

    lazy var countdownFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        let wrongNumberButtonTitle = NSMutableAttributedString(string: NSLocalizedString("WrongNumber", comment: "Wrong number?"), attributes: linkButtonAttributes)
        wrongNumberButton?.setAttributedTitle(wrongNumberButtonTitle, for: .normal)

        let resendCodeButtonTitle = NSMutableAttributedString(string: NSLocalizedString("ResendCode", comment: "Resend Code"), attributes: linkButtonAttributes)
        resendCodeButton?.setAttributedTitle(resendCodeButtonTitle, for: .normal)

        dismissKeyboardOnTap()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let mobileNumber = UserDefaults.standard.string(forKey: "mobileNumber") ?? "Unknown"
        self.titleLabel.text = String(format: NSLocalizedString("EnterOTPSent", comment: "Enter OTP that was sent to 91234567"), mobileNumber)
        startTimer()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _ = codeInputView?.becomeFirstResponder()
    }

    func startTimer() {
        countdownSeconds = OTPViewController.twoMinutes
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(OTPViewController.updateTimerCountdown), userInfo: nil, repeats: true)
        if #available(iOS 13.0, *) {
            expiredMessageLabel?.textColor = .label
        } else {
            expiredMessageLabel?.textColor = .black
        }
        expiredMessageLabel?.isHidden = true
        errorMessageLabel?.isHidden = true
        verifyButton?.isEnabled = true
    }

    @objc
    func updateTimerCountdown() {
        countdownSeconds -= 1

        if countdownSeconds > 0 {
            let countdown = countdownFormatter.string(from: TimeInterval(countdownSeconds))!
            expiredMessageLabel?.text = String(format: NSLocalizedString("CodeWillExpired", comment: "Your code will expired in %@."), countdown)
            expiredMessageLabel?.isHidden = false
        } else {
            timer?.invalidate()
            expiredMessageLabel?.text = NSLocalizedString("CodeHasExpired", comment: "Your code has expired.")
            expiredMessageLabel?.textColor = .red

            verifyButton?.isEnabled = false
        }
    }

    @IBAction func resendCode(_ sender: UIButton) {
        guard let mobileNumber = UserDefaults.standard.string(forKey: "mobileNumber") else {
            performSegue(withIdentifier: "showEnterMobileNumber", sender: self)
            return
        }

        PhoneAuthProvider.provider().verifyPhoneNumber(mobileNumber, uiDelegate: nil) { [weak self] (verificationID, error) in
            if let error = error {
                let errorAlert = UIAlertController(title: "Error verifying phone number", message: error.localizedDescription, preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("Unable to verify phone number")
                }))
                self?.present(errorAlert, animated: true)
                Logger.DLog("Phone number verification error: \(error.localizedDescription)")
                //            self.showMessagePrompt(error.localizedDescription)
                return
            }
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            UserDefaults.standard.set(mobileNumber, forKey: "mobileNumber")
        }

        startTimer()
    }

    func verifyOTP(_ result: @escaping (Status) -> Void) {
        activityIndicator.startAnimating()
        guard let OTP = codeInputView?.text else {
            result(.InvalidOTP)
            return
        }

        guard OTP.range(of: "^[0-9]{6}$", options: .regularExpression) != nil else {
            result(.InvalidOTP)
            return
        }

        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") ?? ""
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: OTP
        )

        Auth.auth().signIn(with: credential) { (_, error) in
            if let error = error {
                // User was not signed in. Display error.
                Logger.DLog(error.localizedDescription)
                result(.WrongOTP)
                return
            }

            FirebaseAPIs.getHandshakePin { (pin) in
                if let pin = pin {
                    UserDefaults.standard.set(pin, forKey: OTPViewController.userDefaultsPinKey)
                    result(.Success)
                } else {
                    result(.WrongOTP)
                    return
                }
            }
            self.activityIndicator.stopAnimating()
        }
    }

    @IBAction func verify(_ sender: UIButton) {
        verifyOTP { [unowned viewController = self] status in
            switch status {
            case .InvalidOTP:
                viewController.errorMessageLabel?.text = NSLocalizedString("InvalidOTP", comment: "Must be a 6-digit code")
                self.errorMessageLabel?.isHidden = false
            case .WrongOTP:
                viewController.errorMessageLabel?.text = NSLocalizedString("WrongOTP", comment: "Wrong OTP entered")
                self.errorMessageLabel?.isHidden = false
            case .Success:
                if !UserDefaults.standard.bool(forKey: "hasConsented") {
                    viewController.performSegue(withIdentifier: "showConsentFromOTPSegue", sender: self)
                } else if !UserDefaults.standard.bool(forKey: "allowedPermissions") {
                    viewController.performSegue(withIdentifier: "showAllowPermissionsFromOTPSegue", sender: self)
                } else if !UserDefaults.standard.bool(forKey: "completedBluetoothOnboarding") {
                    self.performSegue(withIdentifier: "OTPToTurnOnBtSegue", sender: self)
                } else {
                    self.performSegue(withIdentifier: "OTPToHomeSegue", sender: self)
                }
            }
        }
    }

}
