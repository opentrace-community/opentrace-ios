//
//  HealthCheckViewController.swift
//  OpenTrace
//
//  Created by Sam Dods on 15/04/2020.
//  Copyright © 2020 OpenTrace. All rights reserved.
//

import UIKit

class HealthCheckViewController: UIViewController {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    @IBOutlet private var wellButton: UIButton!
    @IBOutlet private var sickButton: UIButton!

    convenience init() {
        self.init(nibName: String(describing: HealthCheckViewController.self), bundle: Bundle(for: HealthCheckViewController.self))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: DisplayStrings.General.cancel, style: .plain, target: self, action: #selector(cancel))

        titleLabel.text = DisplayStrings.Monitoring.HealthCheck.title
        subtitleLabel.text = DisplayStrings.Monitoring.HealthCheck.subtitle
        wellButton.setTitle(DisplayStrings.Monitoring.HealthCheck.feelingWell, for: .normal)
        sickButton.setTitle(DisplayStrings.Monitoring.HealthCheck.feelingSick, for: .normal)
    }

    @objc private func cancel() {
        dismiss(animated: true)
    }

    @IBAction func didTapFeelingWell(_ sender: Any) {
        // TODO: Replace alert with separate screen
        let alert = UIAlertController(title: DisplayStrings.Monitoring.FeelingWell.title, message: DisplayStrings.Monitoring.FeelingWell.subtitle, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: DisplayStrings.Monitoring.FeelingWell.okClose, style: .default, handler: { [weak self] _ in
            self?.dismiss(animated: true)
        }))
        present(alert, animated: true)
    }

    @IBAction func didTapFeelingSick(_ sender: Any) {
        let symptomsViewController = SymptomsViewController()
        navigationController?.pushViewController(symptomsViewController, animated: true)
    }
}
