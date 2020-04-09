import UIKit
import CoreData

final class LogViewController: UIViewController {
    @IBOutlet var logTableView: UITableView!

    var fetchedResultsController: NSFetchedResultsController<Encounter>?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchEncounters()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        logTableView.dataSource = self
        logTableView.register(UITableViewCell.self,
                              forCellReuseIdentifier: "LogCell")
    }

    func fetchEncounters() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Encounter>(entityName: "Encounter")
        let sortByDate = NSSortDescriptor(key: "timestamp", ascending: false)
        fetchRequest.sortDescriptors = [sortByDate]
        fetchedResultsController = NSFetchedResultsController<Encounter>(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self

        do {
            try fetchedResultsController?.performFetch()
        } catch let error as NSError {
            print("Could not perform fetch. \(error), \(error.userInfo)")
        }

    }
}

extension LogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController?.sections else {
            return 0
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogCell", for: indexPath)
        configureCell(cell, at: indexPath)
        return cell
    }

    func configureCell(_ cell: UITableViewCell, at indexPath: IndexPath) {
        guard let encounter = fetchedResultsController?.object(at: indexPath) else {
            return
        }
        let datetime = encounter.timestamp
        let msg = encounter.msg
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .medium
        let timeString = "\(datetime == nil ? "<NONE>" : dateFormatter.string(from: datetime!))"
        cell.textLabel?.text = """
        \(timeString)
        msg: \(msg ?? "<MISSING>")
        modelC: \(encounter.modelC != nil ? "\(encounter.modelC!)" : "nil")
        modelP: \(encounter.modelP != nil ? "\(encounter.modelP!)" : "nil")
        RSSI:  \(encounter.rssi != nil ? "\(encounter.rssi!)" : "nil")
        txPower: \(encounter.txPower != nil ? "\(encounter.txPower!)" : "nil")
        org: \(encounter.org != nil ? "\(encounter.org!)" : "nil")
        v: \(encounter.v != nil ? "\(encounter.v!)" : "nil")
        """
        cell.textLabel?.numberOfLines = 0
    }
}

extension LogViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        logTableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                logTableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case .delete:
            if let indexPath = indexPath {
                logTableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case .update:
            if let indexPath = indexPath, let cell = logTableView.cellForRow(at: indexPath) {
                configureCell(cell, at: indexPath)
            }
            break
        case .move:
            if let indexPath = indexPath {
                logTableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let newIndexPath = newIndexPath {
                logTableView.insertRows(at: [newIndexPath], with: .fade)
            }
            break
        default:
            break
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        logTableView.endUpdates()
    }
}
