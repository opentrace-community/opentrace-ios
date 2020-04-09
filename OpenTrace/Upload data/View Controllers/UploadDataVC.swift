//
//  UploadDataViewController.swift
//  OpenTrace

import UIKit
import CoreData
import Firebase
import FirebaseFunctions

class UploadDataViewController: UIViewController {

    // MARK: - Local
    private var uploadStepsNavigationVC: UINavigationController?
    var _preferredScreenEdgesDeferringSystemGestures: UIRectEdge = []

    // MARK: - Delegates

    override func viewDidLoad() {
        super.viewDidLoad()

        // Add background color for view
        let layer0 = CAGradientLayer()
        layer0.frame = view.bounds
        layer0.colors = [
            UIColor(red: 0.004, green: 0.192, blue: 0.639, alpha: 1).cgColor,
            UIColor(red: 0.004, green: 0.337, blue: 0.859, alpha: 1).cgColor
        ]
        layer0.locations = [0, 1]
        layer0.startPoint = CGPoint(x: 0.25, y: 0.5)
        layer0.endPoint = CGPoint(x: 0.75, y: 0.5)
        view.layer.insertSublayer(layer0, at: 0)

        NotificationCenter.default.addObserver(self, selector: #selector(enableDeferringSystemGestures(_:)), name: .enableDeferringSystemGestures, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(disableDeferringSystemGestures(_:)), name: .disableDeferringSystemGestures, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Reset the Steps navigation vc whenever user re-enter this tab
        uploadStepsNavigationVC?.popToRootViewController(animated: false)

    }

    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return _preferredScreenEdgesDeferringSystemGestures
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @objc
    func enableDeferringSystemGestures(_ notification: Notification) {
        if #available(iOS 11.0, *) {
            _preferredScreenEdgesDeferringSystemGestures = .bottom
            setNeedsUpdateOfScreenEdgesDeferringSystemGestures()
        }
    }

    @objc
    func disableDeferringSystemGestures(_ notification: Notification) {
        if #available(iOS 11.0, *) {
            _preferredScreenEdgesDeferringSystemGestures = []
            setNeedsUpdateOfScreenEdgesDeferringSystemGestures()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? UINavigationController {
            uploadStepsNavigationVC = vc
        }
    }

}
