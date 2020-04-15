//
//  PogoInstructionsViewController.swift
//  OpenTrace

import UIKit

final class PogoInstructionsViewController: UIViewController {

	private typealias Copy = DisplayStrings.Onboarding.PogoInstructions

	@IBOutlet private var headerLabel: UILabel!
	@IBOutlet private var primaryBodyLabel: UILabel!
	@IBOutlet private var secondaryBodyLabel: UILabel!
	@IBOutlet private var faceDownLabel: UILabel!
    @IBOutlet private var upsideDownLabel: UILabel!
	@IBOutlet private var footerLabel: UILabel!
	@IBOutlet private var footerButton: UIButton!

	override func viewDidLoad() {
        super.viewDidLoad()
		setup()

		//TODO: Localize the Bold Text range
		let string1 = Copy.primaryBody
        let boldRange1 = NSRange(location: 31, length: 9)
        let attributedString1 = NSMutableAttributedString(string: string1)
        attributedString1.addAttribute(.font, value: UIFont(name: "Muli-Bold", size: 16)!, range: boldRange1)
        primaryBodyLabel.attributedText = attributedString1

		let string2 = Copy.faceDown
        let boldRange2 = NSRange(location: 19, length: 9)
        let attributedString2 = NSMutableAttributedString(string: string2)
        attributedString2.addAttribute(.font, value: UIFont(name: "Muli-Bold", size: 16)!, range: boldRange2)
        faceDownLabel.attributedText = attributedString2

		let string3 = Copy.upsideDown
        let boldRange3 = NSRange(location: 11, length: 11)
        let attributedString3 = NSMutableAttributedString(string: string3)
        attributedString3.addAttribute(.font, value: UIFont(name: "Muli-Bold", size: 16)!, range: boldRange3)
        upsideDownLabel.attributedText = attributedString3
    }

	private func setup() {
		headerLabel.text = Copy.header
		secondaryBodyLabel.text = Copy.secondaryBody
		footerLabel.text = Copy.footerText
		footerButton.setTitle(Copy.footerButtonTitle, for: .normal)
	}
}
