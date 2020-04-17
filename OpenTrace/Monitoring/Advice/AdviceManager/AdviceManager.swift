//
//  AdviceManager.swift
//  OpenTrace
//
//  Created by Sam Dods on 16/04/2020.
//  Copyright © 2020 OpenTrace. All rights reserved.
//

import Foundation

class AdviceManager {
    
    static let shared = AdviceManager()
    
    let advices1: [Advice]
    let advices2: [Advice]
    
    init() {
        advices1 = Self.loadAdvices(suffix: "1")
        advices2 = Self.loadAdvices(suffix: "2")
    }
    
    private static func loadAdvices(suffix: String) -> [Advice] {
        let path = Bundle(for: Self.self).path(forResource: "Advice\(suffix)", ofType: "json")!
        let data = NSData(contentsOfFile: path)!
        return try! JSONDecoder().decode([Advice].self, from: data as Data)
    }
}
