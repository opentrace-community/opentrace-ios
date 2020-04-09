//
//  PogoMotionManager.swift
//  OpenTrace

import Foundation
import CoreMotion
import UIKit

extension Notification.Name {
    static let enableDeferringSystemGestures = Notification.Name("enableDeferringSystemGestures")
    static let disableDeferringSystemGestures = Notification.Name("disableDeferringSystemGestures")
    static let disableUserInteraction = Notification.Name("disableUserInteraction")
    static let enableUserInteraction = Notification.Name("enableUserInteraction")
}

class PogoMotionManager: NSObject {

    var motionManager: CMMotionManager!
    let blackScreenTag = 123
    var window: UIWindow?

    init(window: UIWindow?) {
        motionManager = CMMotionManager()
        self.window = window
        super.init()
        startAccelerometerUpdates()
    }

    public func startAccelerometerUpdates() {
        let splitAngle: Double = 0.5
        let updateTimer: TimeInterval = 0.5
        motionManager?.accelerometerUpdateInterval = updateTimer
        motionManager?.startAccelerometerUpdates(to: (OperationQueue.current)!, withHandler: { [weak self]
            (acceleroMeterData, error) -> Void in
            if error == nil {
                let acceleration = (acceleroMeterData?.acceleration)!

                if acceleration.y >= splitAngle || acceleration.z >= splitAngle {
                    self?.showBlackscreen()
                } else {
                    self?.dismissBlackscreen()
                }
            } else {
                print("error : \(error!)")
            }
        })
    }

    public func stopAccelerometerUpdates() {
        motionManager?.stopAccelerometerUpdates()
    }

    private func showBlackscreen() {
        if window?.viewWithTag(blackScreenTag) == nil {
            let imageView = UIImageView()
            imageView.frame = window!.frame
            imageView.tag = blackScreenTag
            imageView.contentMode = .scaleAspectFit
            imageView.backgroundColor = .black
            imageView.alpha = 0
            imageView.image = UIImage(named: "watermark")

            window?.addSubview(imageView)
            UIView.animate(withDuration: 0.5) {
                imageView.alpha = 1
            }

            NotificationCenter.default.post(name: .disableUserInteraction, object: nil)
            NotificationCenter.default.post(name: .enableDeferringSystemGestures, object: nil)
        }
    }

    private func dismissBlackscreen() {
        if window?.viewWithTag(blackScreenTag) != nil {
            let imageView = window?.viewWithTag(blackScreenTag)
            imageView?.alpha = 0
            imageView?.removeFromSuperview()

            NotificationCenter.default.post(name: .enableUserInteraction, object: nil)

            NotificationCenter.default.post(name: .disableDeferringSystemGestures, object: nil)
        }
    }

    public func stopAllMotion() {
        self.dismissBlackscreen()
        self.stopAccelerometerUpdates()
    }

}
