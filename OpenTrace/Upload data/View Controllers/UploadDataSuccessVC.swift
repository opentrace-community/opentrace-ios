//
//  UploadDataSuccessVC.swift
//  OpenTrace

import Foundation
import UIKit

final class UploadDataSuccessVC: UIViewController {
      
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subHeadingLabel: UILabel!
    @IBOutlet private var primaryCTA: StyledButton!
    
    private typealias Copy = DisplayStrings.UploadData.UploadSuccess
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        setNavbarToBackgroundColour(withShadow: false)
        setCopy()
    }
    
    private func setCopy() {
        titleLabel.text = Copy.title
        subHeadingLabel.text = Copy.subHeading
        primaryCTA.setTitle(Copy.primaryCTA, for: .normal)
    }
 
    @IBAction func doneBtnTapped(_ sender: UIButton) {
        // Bring user back to home tab
        dismiss(animated: true, completion: nil)
    }
}
