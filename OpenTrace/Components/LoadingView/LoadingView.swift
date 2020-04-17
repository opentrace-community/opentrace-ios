//
//  LoadingView.swift
//  OpenTrace
//
//  Created by Neil Horton on 17/04/2020.
//  Copyright © 2020 OpenTrace. All rights reserved.
//

import UIKit

/// Displays a loading spinner
public final class LoadingView: UIView {
    
    private let activitySpinner = UIActivityIndicatorView(style: .whiteLarge)
    private let backgroundDimmedView = UIView()
    private let shownOpacity: CGFloat = 0.5
    
    public init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        commonInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .clear
        isUserInteractionEnabled = false
        
        backgroundDimmedView.backgroundColor = .white
        backgroundDimmedView.alpha = 0
        addSubview(backgroundDimmedView)
        backgroundDimmedView.translatesAutoresizingMaskIntoConstraints = false
        backgroundDimmedView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        addAndPin(subview: backgroundDimmedView)
        
        activitySpinner.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activitySpinner)
        activitySpinner.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activitySpinner.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        activitySpinner.color = .black
        
    }
    
    /// Show the loading view
    public func show() {
        activitySpinner.startAnimating()
        isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.25) {
            self.backgroundDimmedView.alpha = self.shownOpacity
            self.activitySpinner.alpha = 1
        }
    }
    
    /// Hide the loading view
    public func hide() {
        isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.25, animations: {
            self.backgroundDimmedView.alpha = 0
            self.activitySpinner.alpha = 0
        }, completion: { _ in
            self.activitySpinner.stopAnimating()
        })
    }
}

