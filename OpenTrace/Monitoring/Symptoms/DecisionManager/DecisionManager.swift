//
//  DecisionManager.swift
//  OpenTrace
//
//  Created by Sam Dods on 16/04/2020.
//  Copyright © 2020 OpenTrace. All rights reserved.
//

import Foundation

class DecisionManager {
    
    enum Decision {
        case errorIncomplete
        case noAction, advice, contact
    }
    
    private let symptoms: Symptoms
    
    init() {
        let path = Bundle(for: Self.self).path(forResource: "SymptomQuestions", ofType: "json")!
        let data = NSData(contentsOfFile: path)!
        symptoms = try! JSONDecoder().decode(Symptoms.self, from: data as Data)
    }
    
    var questions: [String] {
        return symptoms.questions.map { $0.text }
    }
    
    func decision(basedOn answers: [Bool?]) -> Decision {
        let answered = answers.compactMap { $0 }
        let isEveryQuestionAnswered = answered.count == symptoms.questions.count
        guard isEveryQuestionAnswered else {
            return .errorIncomplete
        }
        
        switch score(basedOn: answered) {
        case symptoms.thresholdContact...:
            return .contact
        case symptoms.thresholdSeverity2...:
            return .advice
        case symptoms.thresholdSeverity1...:
            return .advice // TODO: there might be two different severities of advice
        default:
            return .noAction
        }
    }
    
    private func score(basedOn answers: [Bool]) -> Int {
        return zip(symptoms.questions, answers)
            .reduce(0) { (result, qa) in
                let (question, answer) = qa
                return result + (answer ? question.yesScore : question.noScore)
        }
    }
}
