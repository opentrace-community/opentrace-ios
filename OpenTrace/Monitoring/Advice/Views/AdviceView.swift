//
//  AdviceView.swift
//  OpenTrace
//
//  Created by Sam Dods on 16/04/2020.
//  Copyright © 2020 OpenTrace. All rights reserved.
//

import UIKit

class AdviceView: UIView {

    @IBOutlet private var adviceLabel: UILabel!

    static func with(advice: String) -> Self {
        let view = loadFromNib()
        view.configure(advice: advice)
        return view
    }
    
    func configure(advice: String) {
        adviceLabel.text = advice
    }
}
