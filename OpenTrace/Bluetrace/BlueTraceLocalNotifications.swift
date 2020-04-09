//
//  BlueTraceLocalNotifications.swift
//  OpenTrace

import Foundation
import UIKit

class BlueTraceLocalNotifications: NSObject {

    static let shared = BlueTraceLocalNotifications()

    func initialConfiguration() {
        UNUserNotificationCenter.current().delegate = self
        setupBluetoothPNStatusCallback()
    }

    // Future update - we have a variable here that stores the permissions state at any point. This variable can be updated everytime app launches / comes into foreground by calling the checkAuthorization (if onboarding has been finished)
    func checkAuthorization(completion: @escaping (_ granted: Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            print("PNS permission granted: \(granted)")
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }

    func setupBluetoothPNStatusCallback() {

        let btStatusMagicNumber = Int.random(in: 0 ... PushNotificationConstants.btStatusPushNotifContents.count - 1)

        BluetraceManager.shared.bluetoothDidUpdateStateCallback = { [unowned self] state in
            if UserDefaults.standard.bool(forKey: "completedBluetoothOnboarding") && !BluetraceManager.shared.isBluetoothOn() {
                if !UserDefaults.standard.bool(forKey: "sentBluetoothStatusNotif") {
                    UserDefaults.standard.set(true, forKey: "sentBluetoothStatusNotif")
                    self.triggerIntervalLocalPushNotifications(pnContent: PushNotificationConstants.btStatusPushNotifContents[btStatusMagicNumber], identifier: "bluetoothStatusNotifId")
                }
            }
        }
    }

    func triggerCalendarLocalPushNotifications(pnContent: [String: String], identifier: String) {

        let center = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        content.title = pnContent["contentTitle"]!
        content.body = pnContent["contentBody"]!

        var dateComponents = DateComponents()
        dateComponents.hour = 9

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        center.add(request)

    }

    func triggerIntervalLocalPushNotifications(pnContent: [String: String], identifier: String) {

        let center = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        content.title = pnContent["contentTitle"]!
        content.body = pnContent["contentBody"]!

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        center.add(request)
    }

    func removePendingNotificationRequests() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}

@available(iOS 10, *)
extension BlueTraceLocalNotifications: UNUserNotificationCenterDelegate {

    // When user receives the notification when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == "bluetoothStatusNotifId" && !BluetraceManager.shared.isBluetoothAuthorized() {
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }
        completionHandler()
    }
}
