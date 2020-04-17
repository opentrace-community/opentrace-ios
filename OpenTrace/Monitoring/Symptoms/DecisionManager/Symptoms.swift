//
//  Symptoms.swift
//  OpenTrace
//
//  Created by Sam Dods on 16/04/2020.
//  Copyright © 2020 OpenTrace. All rights reserved.
//

import Foundation

struct Symptoms: Decodable {

    struct Question: Decodable {
        let text: String
        let yesScore: Int
        let noScore: Int
    }
    
    let thresholdSeverity2: Int
    let thresholdContact: Int
    let questions: [Question]
}
