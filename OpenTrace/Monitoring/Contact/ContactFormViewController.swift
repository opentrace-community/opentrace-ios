//
//  ContactFormViewController.swift
//  OpenTrace
//
//  Created by Sam Dods on 15/04/2020.
//  Copyright © 2020 OpenTrace. All rights reserved.
//

import UIKit

class ContactFormViewController: UIViewController {

    private let fieldNames = [
        "First Name",
        "Last Name",
        "Mobile Phone Number",
        "Email",
        "Postcode",
    ]

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    @IBOutlet private var closingStatement: UILabel!
    @IBOutlet private var finishButton: UIButton!
    @IBOutlet private var fieldsList: UIStackView!
    @IBOutlet private var bottomConstraint: NSLayoutConstraint!
    @IBOutlet private var scrollView: UIScrollView!
    
    convenience init() {
        self.init(nibName: String(describing: Self.self), bundle: Bundle(for: Self.self))
        NotificationCenter.default.addObserver(self, selector: #selector(adjustBottomConstraint), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        typealias Copy = DisplayStrings.Monitoring.ContactForm
        titleLabel.text = Copy.title
        subtitleLabel.text = Copy.subtitle
        closingStatement.text = Copy.closingStatement
        finishButton.setTitle(Copy.submit, for: .normal)
        
        var previousField: ContactFormFieldView?
        for fieldName in fieldNames {
            let field = ContactFormFieldView.with(placeholder: fieldName)
            previousField?.nextField = field
            fieldsList.addArrangedSubview(field)
            previousField = field
        }
    }

    @IBAction private func didTapFinish(_ sender: Any) {
        guard isFormComplete() else {
            presentErrorIncomplete()
            return
        }
        
        let controller = MessageViewController()
        controller.configure(with: .thanksForInfo, onFooterButtonTap: { vc in
            vc.dismiss(animated: true)
        })
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func isFormComplete() -> Bool {
        let incompleteField = fieldsList.arrangedSubviews.first { view in
            ((view as? ContactFormFieldView)?.inputValue.count ?? 0) == 0
        }
        return incompleteField == nil
    }
    
    private func presentErrorIncomplete() {
        typealias Copy = DisplayStrings.Monitoring.ContactForm.ErrorIncomplete
        let alert = UIAlertController(title: Copy.title, message: Copy.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Copy.okClose, style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Keyboard
    
    @objc private func adjustBottomConstraint(_ notification: Notification) {
        guard let window = self.view.window,
            let userInfo = notification.userInfo,
            let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
                return
        }
        
        let endFrame = value.cgRectValue
        let endYPosition = window.frame.height - endFrame.origin.y
        
        bottomConstraint.constant = endYPosition
        
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
        
        makeFocusedFieldVisible(keyboardHeight: endFrame.size.height)
    }
    
    private func makeFocusedFieldVisible(keyboardHeight: CGFloat) {
        guard let focusedField = fieldsList.arrangedSubviews.filter({ $0.isFirstResponder }).first else {
            return // no field selected; nothing to do
        }
        
        var rect = focusedField.convert(focusedField.bounds, to: scrollView)
        rect.origin.y += keyboardHeight
        
        if !scrollView.isDragging {
            scrollView.scrollRectToVisible(rect, animated: true)
        }
    }
}
