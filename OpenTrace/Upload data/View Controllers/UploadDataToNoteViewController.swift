//
//  UploadDataToNoteViewController.swift
//  OpenTrace

import UIKit

final class UploadDataToNoteViewController: UIViewController {
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subheadingLabel: UILabel!
    @IBOutlet private var primaryCTA: StyledButton!
    
    private typealias Copy = DisplayStrings.UploadData.Info
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setCopy() {
        titleLabel.text = Copy.title
        subheadingLabel.text = Copy.subHeading
        primaryCTA.setTitle(Copy.primaryCTA, for: .normal)
    }
}
