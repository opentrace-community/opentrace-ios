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

        // TODO: this will come from the backend, or at least from hardcoded JSON
        [
            "Do you feel like you have a cold?",
            "Do you have a temperature over 38º?",
            "Have you had a temperature over 38º for more than one day?",
            "Do you have a persistent cough?",
            "Are you experiencing unusual fatigue?",
        ].forEach { question in
            let viewModel = BinaryQuestionControl.Model(question: question, answerTrue: "Yes", answerFalse: "No")
            let nib = UINib(nibName: String(describing: BinaryQuestionControl.self), bundle: Bundle(for: BinaryQuestionControl.self))
            let view = nib.instantiate(withOwner: nil, options: nil).first as! BinaryQuestionControl
            view.configure(with: viewModel)
            symptomsList.addArrangedSubview(view)
        }
    }

    @IBAction private func didTapFinish(_ sender: Any) {
        let symptoms = symptomsList.arrangedSubviews.compactMap { $0 as? BinaryQuestionControl }
        let unanswered = symptoms.filter { $0.answer == nil }
        guard unanswered.count == 0 else {
            presentErrorIncomplete()
            return
        }
        checkScore()
    }
    
    private func presentErrorIncomplete() {
        // TODO: localise
        let alert = UIAlertController(title: "Incomplete", message: "You need to answer all questions.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func checkScore() {
        let score = 100
        switch score {
        case 200...:
            showContactForm()
        case 100...200:
            showTips()
        default:
            showTips()
        }
    }
        
    private func showTips() {
        
    }
        
    private func showContactForm() {
        
    }
}
