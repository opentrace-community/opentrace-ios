//
//  Encounter+EncounterRecord.swift
//  OpenTrace

import UIKit
import CoreData

extension EncounterRecord {

    func saveToCoreData() {
        
        // Uncomment to be notified each time an encounter is saved (good for background mode debugging) #bluetooth_debug
//        let content = UNMutableNotificationContent()
//        content.body = self.description
//        UNUserNotificationCenter.current().add(UNNotificationRequest(identifier: "debug", content: content, trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)))
        
        DispatchQueue.main.async {
            guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Encounter", in: managedContext)!
            let encounter = Encounter(entity: entity, insertInto: managedContext)
            encounter.set(encounterStruct: self)
            do {
                try managedContext.save()
            } catch {
                print("Could not save. \(error)")
            }
        }
    }

}
