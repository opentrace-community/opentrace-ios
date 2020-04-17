//
//  ContactFormViewController.swift
//  OpenTrace
//
//  Created by Sam Dods on 15/04/2020.
//  Copyright © 2020 OpenTrace. All rights reserved.
//

import UIKit

class ContactFormViewController: UIViewController {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    @IBOutlet private var closingStatement: UILabel!
    @IBOutlet private var finishButton: UIButton!
    @IBOutlet private var fieldsList: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        typealias Copy = DisplayStrings.Monitoring.ContactForm
        titleLabel.text = Copy.title
        subtitleLabel.text = Copy.subtitle
        closingStatement.text = Copy.closingStatement
        finishButton.setTitle(Copy.submit, for: .normal)
        
        [
            "First Name",
            "Last Name",
            "Mobile Phone Number",
            "Email",
            "Postcode",
        ].forEach { placeholder in
            let view = ContactFormFieldView.with(placeholder: placeholder)
            fieldsList.addArrangedSubview(view)
        }
    }

    @IBAction private func didTapFinish(_ sender: Any) {
        let controller = MessageViewController()
        controller.configure(with: .thanksForInfo, onFooterButtonTap: { vc in
            vc.dismiss(animated: true)
        })
        navigationController?.pushViewController(controller, animated: true)

    }
}
