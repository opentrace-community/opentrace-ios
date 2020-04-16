//
//  SymptomsViewController.swift
//  OpenTrace
//
//  Created by Sam Dods on 15/04/2020.
//  Copyright © 2020 OpenTrace. All rights reserved.
//

import UIKit

class SymptomsViewController: UIViewController {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    @IBOutlet private var closingStatement: UILabel!
    @IBOutlet private var finishButton: UIButton!
    
    convenience init() {
        self.init(nibName: String(describing: SymptomsViewController.self), bundle: Bundle(for: SymptomsViewController.self))
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        typealias Copy = DisplayStrings.Monitoring.TrackSymptoms
        titleLabel.text = Copy.title
        subtitleLabel.text = Copy.subtitle
        closingStatement.text = Copy.closingStatement
        finishButton.setTitle(Copy.submit, for: .normal)
    }

    @IBAction func didTapFinish(_ sender: Any) {
        dismiss(animated: true)
    }
}
