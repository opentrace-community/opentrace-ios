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
    @IBOutlet private var symptomsList: UIStackView!
    
    private let decisionManager = DecisionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        typealias Copy = DisplayStrings.Monitoring.TrackSymptoms
        titleLabel.text = Copy.title
        subtitleLabel.text = Copy.subtitle
        closingStatement.text = Copy.closingStatement
        finishButton.setTitle(Copy.submit, for: .normal)

        decisionManager.questions.forEach { question in
            let viewModel = BinaryQuestionControl.Model(question: question, answerTrue: "Yes", answerFalse: "No")
            let view = BinaryQuestionControl.loadFromNib()
            view.configure(with: viewModel)
            symptomsList.addArrangedSubview(view)
        }
    }

    @IBAction private func didTapFinish(_ sender: Any) {
        let questions = symptomsList.arrangedSubviews.compactMap { $0 as? BinaryQuestionControl }
        let answers = questions.map { $0.answer }
        
        let decision = decisionManager.decision(basedOn: answers)
        
        let next: UIViewController
        switch decision {
        case .errorIncomplete:
            presentErrorIncomplete()
            return
        case .noAction:
            next = FeelingWellViewController()
        case .advice:
            next = AdviceViewController()
        case .contact:
            next = ContactFormViewController()
        }
        navigationController?.pushViewController(next, animated: true)
    }
    
    private func presentErrorIncomplete() {
        typealias Copy = DisplayStrings.Monitoring.TrackSymptoms.ErrorIncomplete
        let alert = UIAlertController(title: Copy.title, message: Copy.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Copy.okClose, style: .default))
        present(alert, animated: true)
    }
}
