//
//  AdviceViewController.swift
//  OpenTrace
//
//  Created by Sam Dods on 15/04/2020.
//  Copyright © 2020 OpenTrace. All rights reserved.
//

import UIKit

struct Advice {
    let question: String
    let recommendations: [String]
}

class AdviceViewController: UIViewController {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    @IBOutlet private var closingStatement: UILabel!
    @IBOutlet private var finishButton: UIButton!
    @IBOutlet private var adviceList: UIStackView!
    
    convenience init() {
        self.init(nibName: String(describing: AdviceViewController.self), bundle: Bundle(for: AdviceViewController.self))
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        typealias Copy = DisplayStrings.Monitoring.Advice
        titleLabel.text = Copy.title
        subtitleLabel.text = Copy.subtitle
        closingStatement.text = Copy.closingStatement
        finishButton.setTitle(Copy.submit, for: .normal)

        // TODO: this will come from the backend, or at least from hardcoded JSON
        [
            Advice(question: "Sed ut perspiciatis unde omnis?", recommendations: [
                "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accus antium.",
            ]),
            Advice(question: "What do I do?", recommendations: [
                "Stay at home.",
                "Don't go shopping or have visitors.",
                "Ask if someone else can walk the dog.",
            ]),
            Advice(question: "Sed ut unde omnis?", recommendations: [
                "Stay at home.",
                "Don't go shopping or have visitors.",
            ]),
            Advice(question: "Sit voluptatem accus antium?", recommendations: [
                "Don't go shopping or have visitors.",
                "Ask if someone else can walk the dog.",
            ])
        ].forEach { advice in
            adviceList.addArrangedSubview(TitleView.with(title: advice.question))
            advice.recommendations.map(AdviceView.with).forEach(adviceList.addArrangedSubview)
        }
    }

    @IBAction private func didTapFinish(_ sender: Any) {
        dismiss(animated: true)
    }
}
