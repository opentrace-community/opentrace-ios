//
//  MessageViewController.swift
//  OpenTrace
//
//  Created by Sam Dods on 15/04/2020.
//  Copyright © 2020 OpenTrace. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    @IBOutlet private var finishButton: UIButton!

    convenience init() {
        self.init(nibName: String(describing: MessageViewController.self), bundle: Bundle(for: MessageViewController.self))
    }

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
