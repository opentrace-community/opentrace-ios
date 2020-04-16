//
//  BinaryQuestionControl.swift
//  OpenTrace
//
//  Created by Sam Dods on 16/04/2020.
//  Copyright © 2020 OpenTrace. All rights reserved.
//

import UIKit

class BinaryQuestionControl: UIView {
    
    struct Model {
        let question: String
        let answerTrue: String
        let answerFalse: String
    }
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var leftButton: StyledButton!
    @IBOutlet private var rightButton: StyledButton!
    private var trueButton: StyledButton { return leftButton }
    private var falseButton: StyledButton { return rightButton }

    var answer: Bool? {
        guard trueButton.isSelected || falseButton.isSelected else {
            return nil
        }
        return trueButton.isSelected
    }

    func configure(with model: Model) {
        titleLabel.text = model.question
        trueButton.setTitle(model.answerTrue, for: .normal)
        falseButton.setTitle(model.answerFalse, for: .normal)
        trueButton.appearance = .primaryHollowRadio
        falseButton.appearance = .primaryHollowRadio
    }
    
    @IBAction private func didTapLeft(_ sender: UIButton) {
        leftButton.isSelected = true
        rightButton.isSelected = false
    }
    
    @IBAction private func didTapRight(_ sender: UIButton) {
        leftButton.isSelected = false
        rightButton.isSelected = true
    }
}
