import UIKit
import FirebaseRemoteConfig
import Lottie
import CoreData

class HomeViewController: UIViewController {

    @IBOutlet weak var screenStack: UIStackView!
    @IBOutlet weak var bluetoothStatusOffView: UIView!
    @IBOutlet weak var bluetoothStatusOnView: UIView!
    @IBOutlet weak var bluetoothPermissionOffView: UIView!
    @IBOutlet weak var bluetoothPermissionOnView: UIView!
    @IBOutlet weak var pushNotificationOnView: UIView!
    @IBOutlet weak var pushNotificationOffView: UIView!
    @IBOutlet weak var incompleteHeaderView: UIView!
    @IBOutlet weak var successHeaderView: UIView!
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    @IBOutlet weak var appPermissionsLabel: UIView!
    @IBOutlet weak var powerSaverCardView: UIView!

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
        animationView.loopMode = LottieLoopMode.playOnce
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
        successHeaderView.isVisible = self.allPermissionOn
        powerSaverCardView.isVisible = self.allPermissionOn
        incompleteHeaderView.isVisible = !self.allPermissionOn
        appPermissionsLabel.isVisible = !self.allPermissionOn
    }

    private func toggleBluetoothStatusView() {
        bluetoothStatusOnView.isVisible = !self.allPermissionOn && self.blePoweredOn
        bluetoothStatusOffView.isVisible = !self.allPermissionOn && !self.blePoweredOn
    }

    private func toggleBluetoothPermissionStatusView() {
        bluetoothPermissionOnView.isVisible = !self.allPermissionOn && self.bleAuthorized
        bluetoothPermissionOffView.isVisible = !self.allPermissionOn && !self.bleAuthorized
    }

    private func togglePushNotificationsStatusView() {
        pushNotificationOnView.isVisible = !self.allPermissionOn && self.pushNotificationGranted
        pushNotificationOffView.isVisible = !self.allPermissionOn && !self.pushNotificationGranted
    }

    @IBAction func onHeroTapped(_ sender: UITapGestureRecognizer) {
        Logger.DLog("tapped")
        #if DEBUG
        self.performSegue(withIdentifier: "HomeToDebugSegue", sender: self)
        #endif
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

    @IBAction func onPowerSaverButtonTapped(_ sender: Any) {

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
            setInitialLastUpdatedTime()
        } catch let error as NSError {
            print("Could not perform fetch. \(error), \(error.userInfo)")
        }

    }

    func setInitialLastUpdatedTime() {
        guard let encounters = fetchedResultsController?.fetchedObjects else {
            return
        }
        guard encounters.count > 0 else {
            return
        }
        let firstEncounter = encounters[0]
        updateLastUpdatedTime(date: firstEncounter.timestamp!)
    }

    func updateLastUpdatedTime(date: Date) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        lastUpdatedLabel.text = "Last updated: \(formatter.string(from: date))"
    }

    func playActivityAnimation() {
        animationView.play()
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
                self.playActivityAnimation()
            }
            self.updateLastUpdatedTime(date: Date())
            break
        default:
            self.updateLastUpdatedTime(date: Date())
            break
        }
    }
}
