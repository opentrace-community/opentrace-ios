import UIKit
import FirebaseRemoteConfig
import Lottie
import CoreData

class HomeViewController: UIViewController {

    @IBOutlet weak var screenStack: UIStackView!
    @IBOutlet weak var shareView: UIView!
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var bodyLabel: UILabel!
	@IBOutlet var trackingInfoButton: UIButton!

	var fetchedResultsController: NSFetchedResultsController<Encounter>?

    var allPermissionOn = true
    var bleAuthorized = true
    var blePoweredOn = true
    var pushNotificationGranted = true
    var remoteConfig = RemoteConfig.remoteConfig()

    var _preferredScreenEdgesDeferringSystemGestures: UIRectEdge = []

    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return _preferredScreenEdgesDeferringSystemGestures
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        observeNotifications()
		setup()
    }

    func observeNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(enableDeferringSystemGestures(_:)), name: .enableDeferringSystemGestures, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(disableDeferringSystemGestures(_:)), name: .disableDeferringSystemGestures, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(disableUserInteraction(_:)), name: .disableUserInteraction, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(enableUserInteraction(_:)), name: .enableUserInteraction, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.readPermissionsAndUpdateViews()
        self.fetchEncounters()
    }

    @objc private func applicationDidBecomeActive() {
        readPermissionsAndUpdateViews()
    }

	func setup() {
		// TODO: Localise strings once Sam's HomeStrings.swift is merged
		titleLabel.text = "The Coronavirus COVID-19 Lockdown App"
		titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
		bodyLabel.text = "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accus antium dolore mque lauda ntium esparanti dollo fiunti est forunti."
		bodyLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
		let buttonTitle = NSAttributedString(string: "Check what we are tracking",
											 attributes: [NSAttributedString.Key.foregroundColor: UIColor.black,
														  NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),
														  NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
		trackingInfoButton.setAttributedTitle(buttonTitle, for: .normal)

	}

    private func togglePermissionViews() {
        togglePushNotificationsStatusView()
        toggleBluetoothStatusView()
        toggleBluetoothPermissionStatusView()
        toggleIncompleteHeaderView()
    }

    private func readPermissionsAndUpdateViews() {

        blePoweredOn = BluetraceManager.shared.isBluetoothOn()
        bleAuthorized = BluetraceManager.shared.isBluetoothAuthorized()

        BlueTraceLocalNotifications.shared.checkAuthorization { (pnsGranted) in
            self.pushNotificationGranted = pnsGranted

            self.allPermissionOn = self.blePoweredOn && self.bleAuthorized && self.pushNotificationGranted

            self.togglePermissionViews()
        }
    }

    private func toggleIncompleteHeaderView() {
    }

    private func toggleBluetoothStatusView() {
    }

    private func toggleBluetoothPermissionStatusView() {
    }

    private func togglePushNotificationsStatusView() {
    }

	@IBAction func TrackMyConditionButtonTapped() {
		let healthCheckViewController = HealthCheckViewController()
		let navigationController = TransparentNavController(rootViewController: healthCheckViewController)
		present(navigationController, animated: true)
	}

	@IBAction func onShareTapped(_ sender: UITapGestureRecognizer) {
        let shareText = TracerRemoteConfig.instance.configValue(forKey: "ShareText").stringValue ?? TracerRemoteConfig.defaultShareText
        let activity = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        activity.popoverPresentationController?.sourceView = shareView

        present(activity, animated: true, completion: nil)
    }

    @objc
    func enableUserInteraction(_ notification: Notification) {
        self.view.isUserInteractionEnabled = true
    }

    @objc
    func disableUserInteraction(_ notification: Notification) {
        self.view.isUserInteractionEnabled = false
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

    func fetchEncounters() {
        let sortByDate = NSSortDescriptor(key: "timestamp", ascending: false)

        fetchedResultsController = DatabaseManager.shared().getFetchedResultsController(Encounter.self, with: nil, with: sortByDate, prefetchKeyPaths: nil, delegate: self)

        do {
            try fetchedResultsController?.performFetch()
        } catch let error as NSError {
            print("Could not perform fetch. \(error), \(error.userInfo)")
        }

    }
}

struct TracerRemoteConfig {
    static private(set) var instance: RemoteConfig!
    static let defaultShareText = "Join me in stopping the spread of COVID-19! Download OpenTrace!"

    init() {
        // Setup remote config
        TracerRemoteConfig.instance = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 3600
        TracerRemoteConfig.instance.configSettings = settings

        let defaultValue = ["ShareText": TracerRemoteConfig.defaultShareText as NSObject]
        TracerRemoteConfig.instance.setDefaults(defaultValue)
        TracerRemoteConfig.instance.fetch(withExpirationDuration: TimeInterval(3600)) { (status, error) -> Void in
            if status == .success {
                Logger.DLog("Remote config fetch success")
                TracerRemoteConfig.instance.activate { (error) in
                    Logger.DLog("Remote config activate\(error == nil ? "" : " with error \(error!)")")
                }
            } else {
                Logger.DLog("Config not fetched")
                Logger.DLog("Error: \(error?.localizedDescription ?? "No error available.")")
            }
        }
    }
}

extension HomeViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            let encounter = anObject as! Encounter
            if ![Encounter.Event.scanningStarted.rawValue, Encounter.Event.scanningStopped.rawValue].contains(encounter.msg) {
            }
            break
        default:
            break
        }
    }
}
