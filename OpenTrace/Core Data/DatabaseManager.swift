//This class abstracts a fair bit of the Core Data functionality. Improvements can be made with respect to extending it to better support FetchedResultsControllers.

import Foundation
import CoreData
import UIKit

protocol AsynchronousFetchCallbackHandler: NSObjectProtocol {
    func fetchSuccess(_ objects: [Any]?, handlerContext: [AnyHashable: Any]?)
    func fetchFailed(_ handlerContext: [AnyHashable: Any]?)
}

class DatabaseManager {

    var persistentContainer: NSPersistentContainer!

    private static var sharedManager: DatabaseManager?

    static func shared() -> DatabaseManager {
        if sharedManager == nil {
            sharedManager = DatabaseManager()
        }
        return sharedManager!
    }

    func saveDatabaseContext () {

        let context = persistentContainer.viewContext

        if context.hasChanges {
            context.perform {
                do {
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }

    func getObjectsWithMultipleFiltersOf<T>(_ classObject: T.Type, with predicates: [NSPredicate]?, predicateType: NSCompoundPredicate.LogicalType = NSCompoundPredicate.LogicalType.and, with sortDescriptor: NSSortDescriptor?, prefetchKeyPaths prefetchKeypaths: [Any]?, fetchLimit: Int = 100) -> [T]? where T: NSManagedObject {

        var compositePredicate: NSPredicate?

        if let predicates = predicates, predicates.count > 0 {
            if predicates.count > 1 {
                compositePredicate = NSCompoundPredicate(type: predicateType, subpredicates: predicates)
            } else {
                compositePredicate = predicates[0]
            }
        }

        return getObjectsOf(classObject, with: compositePredicate, with: sortDescriptor, prefetchKeyPaths: prefetchKeypaths)
    }

    private func getFetchRequestFor<T>(_ classObject: T.Type, with predicate: NSPredicate?, with sortDescriptor: NSSortDescriptor?, prefetchKeyPaths prefetchKeypaths: [Any]?, fetchLimit: Int = 100, context: NSManagedObjectContext)
        -> NSFetchRequest<T> where T: NSManagedObject {

        let fetchRequest = NSFetchRequest<T>()
        let entityDescription = NSEntityDescription.entity(forEntityName: NSStringFromClass(classObject.self), in: context)
        fetchRequest.entity = entityDescription

        if predicate != nil {
            fetchRequest.predicate = predicate
        }
        if sortDescriptor != nil {
            fetchRequest.sortDescriptors = [sortDescriptor] as? [NSSortDescriptor]
        }
        if prefetchKeypaths != nil {
            fetchRequest.relationshipKeyPathsForPrefetching = prefetchKeypaths as? [String]
        }

        if(fetchLimit > 0) {
            fetchRequest.fetchLimit = fetchLimit
        }

        return fetchRequest
    }

    //This fetches objects synchronously.
    //This needs to be called only from the main thread since it uses the main view context
    //Refactor to use context.perform if we want to support flexibility with the context later
    func getObjectsOf<T>(_ classObject: T.Type, with predicate: NSPredicate?, with sortDescriptor: NSSortDescriptor?, prefetchKeyPaths prefetchKeypaths: [Any]?, fetchLimit: Int = -1) -> [T]? where T: NSManagedObject {

        let context = persistentContainer.viewContext

        let fetchRequest = getFetchRequestFor(classObject, with: predicate, with: sortDescriptor, prefetchKeyPaths: prefetchKeypaths, fetchLimit: fetchLimit, context: context)

        var result: [T]!

        do {
            result = try context.fetch(fetchRequest)
        } catch {
            print("Error occured: \(error). Error description : \(error.localizedDescription)")
        }

        if (result == nil) {
            result = [T]()
        }

        return result
    }

    //This fetches objects asynchronously
    func getObjectsOfClassAsynchronous(_ classObject: NSManagedObject.Type, with predicate: NSPredicate?, with sortDescriptor: NSSortDescriptor?, prefetchKeyPaths prefetchKeypaths: [Any]?, fetchLimit: Int = -1, callbackHandler: AsynchronousFetchCallbackHandler?, handlerContext: [AnyHashable: Any]?) {

        let context: NSManagedObjectContext = persistentContainer.viewContext

        let fetchRequest = getFetchRequestFor(classObject, with: predicate, with: sortDescriptor, prefetchKeyPaths: prefetchKeypaths, fetchLimit: fetchLimit, context: context)

        let asynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest, completionBlock: { result in
            DispatchQueue.main.async(execute: {
                callbackHandler?.fetchSuccess(result.finalResult, handlerContext: handlerContext)
            })
        })

        context.perform {
            do {
                try context.execute(asynchronousFetchRequest)
            } catch {
                print("Error occured: \(error). Error description : \(error.localizedDescription)")
                callbackHandler!.fetchFailed(handlerContext)
            }
        }
    }

    func getFetchedResultsController<T>(_ classObject: T.Type, with predicate: NSPredicate?, with sortDescriptor: NSSortDescriptor?, prefetchKeyPaths prefetchKeypaths: [Any]?, fetchLimit: Int = -1, delegate: NSFetchedResultsControllerDelegate? = nil) -> NSFetchedResultsController<T> where T: NSManagedObject {

        let context = persistentContainer.viewContext

        let fetchRequest = getFetchRequestFor(classObject, with: predicate, with: sortDescriptor, prefetchKeyPaths: prefetchKeypaths, fetchLimit: fetchLimit, context: context)

        let fetchedResultsController = NSFetchedResultsController<T>(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)

        if let delegate = delegate {
            fetchedResultsController.delegate = delegate
        }

        return fetchedResultsController
    }

    func deleteObjectsOf<T>(_ classObject: T.Type, with predicate: NSPredicate?) where T: NSManagedObject {

        let context = persistentContainer.viewContext

        context.perform {
            let objectsToDelete = self.getObjectsOf(classObject, with: predicate, with: nil, prefetchKeyPaths: nil)
            for object in objectsToDelete! {
                context.delete(object)
                self.saveDatabaseContext()
            }
        }
    }

    func delete(object: NSManagedObject) {
        let context = persistentContainer.viewContext
        context.perform {
            context.delete(object)
            self.saveDatabaseContext()
        }
    }

    func deleteSetOfObjects(set: Set<NSManagedObject>) {
        let context = persistentContainer.viewContext
        context.perform {
            for object in set {
                context.delete(object)
            }
            self.saveDatabaseContext()
        }
    }

    func createObjectOf<T>(_ classObject: T.Type) -> T? where T: NSManagedObject {

        let context = persistentContainer.viewContext

        let entityDescription = NSEntityDescription.entity(forEntityName: NSStringFromClass(classObject.self), in: context)

        let managedObject = classObject.init(entity: entityDescription!, insertInto: context)

        return managedObject
    }

    func createObjectOf<T>(_ classObject: T.Type, andProperties properties: [AnyHashable: Any]?) -> T? where T: NSManagedObject {

        let context = persistentContainer.viewContext

        let entityDescription = NSEntityDescription.entity(forEntityName: NSStringFromClass(classObject.self), in: context)

        var createdObject: T?

        if let entityDescription = entityDescription {
            createdObject = classObject.init(entity: entityDescription, insertInto: context)
        }

        for propertyKey in (properties?.keys)! {
            if createdObject?.responds(to: NSSelectorFromString(propertyKey as! String)) ?? false && properties?[propertyKey] != nil && !(properties?[propertyKey] is NSNull) {
                createdObject?.setValue(properties?[propertyKey], forKey: propertyKey as! String)
            } else {

            }
        }

        return createdObject
    }

}
