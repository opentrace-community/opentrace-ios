//
//  PogoInstructionsViewController.swift
//  OpenTrace

import UIKit

class PogoInstructionsViewController: UIViewController {

    @IBOutlet weak var keptOpenLabel: UILabel!
    @IBOutlet weak var faceDownLabel: UILabel!
    @IBOutlet weak var upsideDownLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        let string1 = "On iPhone, the app needs to be kept open to work."
        let boldRange1 = NSRange(location: 31, length: 9)
        let attributedString1 = NSMutableAttributedString(string: string1)
        attributedString1.addAttribute(.font, value: UIFont(name: "Muli-Bold", size: 16)!, range: boldRange1)
        keptOpenLabel.attributedText = attributedString1

        let string2 = "1. Turn your phone face down, or"
        let boldRange2 = NSRange(location: 19, length: 9)
        let attributedString2 = NSMutableAttributedString(string: string2)
        attributedString2.addAttribute(.font, value: UIFont(name: "Muli-Bold", size: 16)!, range: boldRange2)
        faceDownLabel.attributedText = attributedString2

        let string3 = "2. Keep it upside down in your pocket"
        let boldRange3 = NSRange(location: 11, length: 11)
        let attributedString3 = NSMutableAttributedString(string: string3)
        attributedString3.addAttribute(.font, value: UIFont(name: "Muli-Bold", size: 16)!, range: boldRange3)
        upsideDownLabel.attributedText = attributedString3
    }
}
