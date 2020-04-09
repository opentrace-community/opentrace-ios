//
//  BluetraceUtils.swift
//  OpenTrace

import UIKit
import CoreData
import Foundation
import CoreBluetooth

class BluetraceUtils {
    static func managerStateToString(_ state: CBManagerState) -> String {
        switch state {
        case .poweredOff:
            return "poweredOff"
        case .poweredOn:
            return "poweredOn"
        case .resetting:
            return "resetting"
        case .unauthorized:
            return "unauthorized"
        case .unknown:
            return "unknown"
        case .unsupported:
            return "unsupported"
        default:
            return "unknown"
        }
    }

    static func peripheralStateToString(_ state: CBPeripheralState) -> String {
        switch state {
        case .disconnected:
            return "disconnected"
        case .connecting:
            return "connecting"
        case .connected:
            return "connected"
        case .disconnecting:
            return "disconnecting"
        default:
            return "unknown"
        }
    }

    static func removeData21DaysOld() {
        Logger.DLog("Removing 21 days old data from device!")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Encounter>(entityName: "Encounter")
        fetchRequest.includesPropertyValues = false

        // For e.g. 31st of March, we get reverseCutOffDate of 10th March
        let reverseCutOffDate: Date? = Calendar.current.date(byAdding: .day, value: BluetraceConfig.TTLDays, to: Date())
        if let validDate = reverseCutOffDate {
            let predicateForDel = NSPredicate(format: "timestamp < %@", validDate as NSDate)
            fetchRequest.predicate = predicateForDel
            do {
                let encounters = try managedContext.fetch(fetchRequest)
                for encounter in encounters {
                    managedContext.delete(encounter)
                }
                try managedContext.save()
            } catch {
                print("Could not perform delete of old data. \(error)")
            }
        }
    }
}
