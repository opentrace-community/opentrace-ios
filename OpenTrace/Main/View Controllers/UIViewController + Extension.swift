import Foundation
import UIKit

extension UIViewController {
    // Calling this function will add a tap gesture to the view. On tap, the keyboard will be dismissed
    func dismissKeyboardOnTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(OTPViewController.dismissKeyboard))
               view.addGestureRecognizer(tap)
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
