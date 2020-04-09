import UIKit
import CoreData

final class ContactViewController: UIViewController {
    @IBOutlet var contactTableView: UITableView!
    var sortedContacts:[(contactId: String, count: Int)] = []
    var fetchedResultsController: NSFetchedResultsController<Encounter>?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchContacts()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        contactTableView.dataSource = self
        contactTableView.register(UITableViewCell.self,
                                  forCellReuseIdentifier: "ContactCell")
    }

    func fetchContacts() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = Encounter.fetchRequestForRecords()
        fetchedResultsController = NSFetchedResultsController<Encounter>(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self

        do {
            try fetchedResultsController?.performFetch()
            updateSortedContacts()
        } catch let error as NSError {
            print("Could not perform fetch. \(error), \(error.userInfo)")
        }

    }

    func updateSortedContacts() {
        guard let encounters = fetchedResultsController?.fetchedObjects else {
            return
        }
        var contactCounts: [String: Int] = [:]
        for encounter in encounters {
            if encounter.msg != nil {
                if contactCounts[encounter.msg!] == nil {
                    contactCounts[encounter.msg!] = 0
                }
                contactCounts[encounter.msg!]! += 1
            }
        }
        var contactTuples = contactCounts.map { ($0.key, $0.value) }
        contactTuples.sort {
            $0.1 > $1.1
        }
        sortedContacts = contactTuples
    }
}

extension ContactViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sortedContacts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
        let contact = self.sortedContacts[indexPath.row]
        cell.textLabel?.text = "\(contact.contactId) [\(contact.count) encounters]"
        cell.textLabel?.numberOfLines = 0
        return cell
    }
}

extension ContactViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        updateSortedContacts()
        contactTableView.reloadData()
    }
}
