import Foundation
import UIKit

@IBDesignable
class VariableHeightProgressView: UIProgressView {

    @IBInspectable
    var progressBarHeight: CGFloat = 2.0 {
        didSet {
            let transform = CGAffineTransform(scaleX: 1.0, y: progressBarHeight)
            self.transform = transform
        }
    }
}
