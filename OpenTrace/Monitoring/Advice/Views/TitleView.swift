//
//  TitleView.swift
//  OpenTrace
//
//  Created by Sam Dods on 16/04/2020.
//  Copyright © 2020 OpenTrace. All rights reserved.
//

import UIKit

class TitleView: UIView {
    
    @IBOutlet private var titleLabel: UILabel!
    
    static func with(title: String) -> Self {
        let view = loadFromNib()
        view.configure(title: title)
        return view
    }

    func configure(title: String) {
        titleLabel.text = title
    }
}
