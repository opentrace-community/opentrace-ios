//
//  GradientButton.swift
//  OpenTrace

import UIKit

@IBDesignable
class GradientButton: UIButton {
    let gradientLayer = CAGradientLayer()

    @IBInspectable
    var topGradientColor: UIColor?

    @IBInspectable
    var bottomGradientColor: UIColor?

    private func setGradient(topGradientColor: UIColor?, bottomGradientColor: UIColor?) {
        if let topGradientColor = topGradientColor, let bottomGradientColor = bottomGradientColor {
            gradientLayer.frame = bounds
            gradientLayer.colors = [topGradientColor.cgColor, bottomGradientColor.cgColor]
            gradientLayer.borderColor = layer.borderColor
            gradientLayer.borderWidth = layer.borderWidth
            gradientLayer.cornerRadius = layer.cornerRadius
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
            gradientLayer.locations = [0.0, 1.0]
            layer.insertSublayer(gradientLayer, at: 0)
        } else {
            gradientLayer.removeFromSuperlayer()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        setGradient(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor)
    }

}
