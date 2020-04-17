//
//  Advice.swift
//  OpenTrace
//
//  Created by Sam Dods on 16/04/2020.
//  Copyright © 2020 OpenTrace. All rights reserved.
//

import Foundation

struct Advice: Decodable {
    let question: String
    let recommendations: [String]
}
