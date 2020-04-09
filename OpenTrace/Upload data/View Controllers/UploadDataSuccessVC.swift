//
//  UploadDataSuccessVC.swift
//  OpenTrace

import Foundation
import UIKit

class UploadDataSuccessVC: UIViewController {
    @IBAction func doneBtnTapped(_ sender: UIButton) {
        // Bring user back to home tab
        self.navigationController?.tabBarController?.selectedIndex = 0
    }
}
