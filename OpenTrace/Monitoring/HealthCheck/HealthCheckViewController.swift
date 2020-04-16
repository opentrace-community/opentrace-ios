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
    @IBOutlet private var wellButton: StyledButton!
    @IBOutlet private var sickButton: StyledButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: DisplayStrings.General.cancel, style: .plain, target: self, action: #selector(cancel))

        typealias Copy = DisplayStrings.Monitoring.HealthCheck
        titleLabel.text = Copy.title
        subtitleLabel.text = Copy.subtitle
        wellButton.setTitle(Copy.feelingWell, for: .normal)
        sickButton.setTitle(Copy.feelingSick, for: .normal)
        wellButton.appearance = .primaryHollow
        sickButton.appearance = .primaryHollow
    }

    @objc private func cancel() {
        dismiss(animated: true)
    }

    @IBAction func didTapFeelingWell(_ sender: Any) {
		let feelingWellViewController = MessageViewController()
		feelingWellViewController.configure(with: .feelingGood, onFooterButtonTap: { vc in
			vc.dismiss(animated: true)
		})
        navigationController?.pushViewController(feelingWellViewController, animated: true)
    }

    @IBAction func didTapFeelingSick(_ sender: Any) {
        let symptomsViewController = SymptomsViewController()
        navigationController?.pushViewController(symptomsViewController, animated: true)
    }
}
