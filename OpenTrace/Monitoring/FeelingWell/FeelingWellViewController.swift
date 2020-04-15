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
    @IBOutlet private var wellButton: UIButton!
    @IBOutlet private var sickButton: UIButton!

    convenience init() {
        self.init(nibName: String(describing: FeelingWellViewController.self), bundle: Bundle(for: FeelingWellViewController.self))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: DisplayStrings.General.cancel, style: .plain, target: self, action: #selector(cancel))

        typealias Copy = DisplayStrings.Monitoring.HealthCheck
        titleLabel.text = Copy.title
        subtitleLabel.text = Copy.subtitle
        wellButton.setTitle(Copy.feelingWell, for: .normal)
        sickButton.setTitle(Copy.feelingSick, for: .normal)
    }

    @objc private func cancel() {
        dismiss(animated: true)
    }

    @IBAction func didTapFeelingWell(_ sender: Any) {
        // TODO: Replace alert with separate screen
        typealias Copy = DisplayStrings.Monitoring.FeelingWell
        let alert = UIAlertController(title: Copy.title, message: Copy.subtitle, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Copy.okClose, style: .default, handler: { [weak self] _ in
            self?.dismiss(animated: true)
        }))
        present(alert, animated: true)
    }

    @IBAction func didTapFeelingSick(_ sender: Any) {
        let symptomsViewController = SymptomsViewController()
        navigationController?.pushViewController(symptomsViewController, animated: true)
    }
}
