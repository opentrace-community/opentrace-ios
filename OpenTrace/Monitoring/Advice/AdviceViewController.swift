//
//  AdviceViewController.swift
//  OpenTrace
//
//  Created by Sam Dods on 15/04/2020.
//  Copyright © 2020 OpenTrace. All rights reserved.
//

import UIKit

class AdviceViewController: UIViewController {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    @IBOutlet private var closingStatement: UILabel!
    @IBOutlet private var finishButton: UIButton!
    @IBOutlet private var adviceList: UIStackView!
    private let advices: [Advice]
    
    required init(advices: [Advice]) {
        self.advices = advices
        super.init(nibName: String(describing: Self.self), bundle: Bundle(for: Self.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        typealias Copy = DisplayStrings.Monitoring.Advice
        titleLabel.text = Copy.title
        subtitleLabel.text = Copy.subtitle
        closingStatement.text = Copy.closingStatement
        finishButton.setTitle(Copy.okClose, for: .normal)

        advices.forEach { advice in
            adviceList.addArrangedSubview(TitleView.with(title: advice.question))
            advice.recommendations.map(AdviceView.with).forEach(adviceList.addArrangedSubview)
        }
    }

    @IBAction private func didTapFinish(_ sender: Any) {
        dismiss(animated: true)
    }
}
