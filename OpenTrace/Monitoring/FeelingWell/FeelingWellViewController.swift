//
//  FeelingWellViewController.swift
//  OpenTrace
//
//  Created by Sam Dods on 15/04/2020.
//  Copyright © 2020 OpenTrace. All rights reserved.
//

import UIKit

class FeelingWellViewController: UIViewController {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    @IBOutlet private var finishButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        typealias Copy = DisplayStrings.Monitoring.FeelingWell
        titleLabel.text = Copy.title
        subtitleLabel.text = Copy.subtitle
        finishButton.setTitle(Copy.okClose, for: .normal)
    }

    @IBAction func didTapFinish(_ sender: Any) {
        dismiss(animated: true)
    }
}
