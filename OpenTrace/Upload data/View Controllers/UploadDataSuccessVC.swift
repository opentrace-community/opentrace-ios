//
//  UploadDataSuccessVC.swift
//  OpenTrace

import Foundation
import UIKit

final class UploadDataSuccessVC: UIViewController {
      
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subHeadingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        setTransparentNavBar()
    }
 
    @IBAction func doneBtnTapped(_ sender: UIButton) {
        // Bring user back to home tab
        dismiss(animated: true, completion: nil)
    }
}
