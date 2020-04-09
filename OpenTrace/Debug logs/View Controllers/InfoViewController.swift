import UIKit
import CoreData
import FirebaseAuth

final class InfoViewController: UIViewController {
    @IBOutlet weak var devicesEncounteredLabel: UILabel!
    @IBOutlet weak var clearLogsButton: UIButton!
    @IBOutlet weak var advertisementSwitch: UISwitch!
    @IBOutlet weak var scanningSwitch: UISwitch!
    @IBOutlet weak var centralStateLabel: UILabel!
    @IBOutlet weak var obtainBluetoothStateButton: UIButton!
    @IBOutlet weak var peripheralStateLabel: UILabel!
    private var devicesEncounteredCount: Int?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDevicesEncounteredCount()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        advertisementSwitch.addTarget(self, action: #selector(self.advertisementSwitchChanged), for: UIControl.Event.valueChanged)
        scanningSwitch.addTarget(self, action: #selector(self.scanningSwitchChanged), for: UIControl.Event.valueChanged)
        clearLogsButton.addTarget(self, action: #selector(self.clearLogsButtonClicked), for: .touchUpInside)
        obtainBluetoothStateButton.addTarget(self, action: #selector(self.obtainBluetoothStateButtonClicked), for: .touchUpInside)
    }

    @IBAction func logoutBtn(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            let navController = self.navigationController!
            let storyboard = navController.storyboard!
            let introVC = storyboard.instantiateViewController(withIdentifier: "intro")
            navController.setViewControllers([introVC], animated: false)
        } catch {
            print("Unable to log out")
        }

    }

    @objc
    func fetchDevicesEncounteredCount() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSDictionary>(entityName: "Encounter")
        fetchRequest.resultType = .dictionaryResultType
        fetchRequest.propertiesToFetch = ["msg"]
        fetchRequest.returnsDistinctResults = true

        do {
            let devicesEncountered = try managedContext.fetch(fetchRequest)
            self.devicesEncounteredLabel.text = String(devicesEncountered.count)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    @objc
    func advertisementSwitchChanged(mySwitch: UISwitch) {
        BluetraceManager.shared.toggleAdvertisement(mySwitch.isOn)
    }

    @objc
    func scanningSwitchChanged(mySwitch: UISwitch) {
        BluetraceManager.shared.toggleScanning(mySwitch.isOn)
    }

    @objc
    func clearLogsButtonClicked() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Encounter>(entityName: "Encounter")
        fetchRequest.includesPropertyValues = false
        do {
            let encounters = try managedContext.fetch(fetchRequest)
            for encounter in encounters {
                managedContext.delete(encounter)
            }
            try managedContext.save()
        } catch {
            print("Could not perform delete. \(error)")
        }
    }

    @objc
    func obtainBluetoothStateButtonClicked() {
        self.centralStateLabel.text = "Central state: \(BluetraceManager.shared.getCentralStateText())"
        self.peripheralStateLabel.text = "Peripheral state: \(BluetraceManager.shared.getPeripheralStateText())"
    }
}
