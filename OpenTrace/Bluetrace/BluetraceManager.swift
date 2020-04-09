import UIKit
import CoreData
import CoreBluetooth

class BluetraceManager {

    private var peripheralController: PeripheralController!
    private var centralController: CentralController!

    var queue: DispatchQueue!
    var bluetoothDidUpdateStateCallback: ((CBManagerState) -> Void)?

    static let shared = BluetraceManager()

    private init() {
        queue = DispatchQueue(label: "BluetraceManager")
        peripheralController = PeripheralController(peripheralName: "TR", queue: queue)
        centralController = CentralController(queue: queue)
        centralController.centralDidUpdateStateCallback = centralDidUpdateStateCallback
    }

    func initialConfiguration() {

    }

    func presentBluetoothAlert(_ bluetoothStateString: String) {
        #if DEBUG
        let alert = UIAlertController(title: "Bluetooth Issue: "+bluetoothStateString+" on "+DeviceInfo.getModel()+" iOS: "+UIDevice.current.systemVersion, message: "Please screenshot this message and send to support!", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

        DispatchQueue.main.async {
            var topController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
            while topController?.presentedViewController != nil {
                topController = topController?.presentedViewController
            }

            topController?.present(alert, animated: true)
        }
        #endif

        #if RELEASE
        let alert = UIAlertController(title: "App restart required for Bluetooth to restart!", message: "Press Ok to exit the app!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
            exit(0)
        }))
        DispatchQueue.main.async {
            var topController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
            while topController?.presentedViewController != nil {
                topController = topController?.presentedViewController
            }

            if topController!.isKind(of: UIAlertController.self) {
                print("Alert has already popped up!")
            } else {
                topController?.present(alert, animated: true)
            }

        }
        #endif
    }

    func turnOn() {
        peripheralController.turnOn()
        centralController.turnOn()
    }

    func turnOff() {
        peripheralController.turnOff()
        centralController.turnOff()
    }

    func getCentralStateText() -> String {
        guard centralController.getState() != nil else {
            return "nil"
        }
        return BluetraceUtils.managerStateToString(centralController.getState()!)
    }

    func getPeripheralStateText() -> String {
        return BluetraceUtils.managerStateToString(peripheralController.getState())
    }

    func isBluetoothAuthorized() -> Bool {
        if #available(iOS 13.1, *) {
            return CBManager.authorization == .allowedAlways
        } else {
            // todo: consider iOS 13.0, which has different behavior from 13.1 onwards
            return CBPeripheralManager.authorizationStatus() == .authorized
        }
    }

    func isBluetoothOn() -> Bool {
        switch centralController.getState() {
        case .poweredOff:
            print("Bluetooth is off")
        case .resetting:
            presentBluetoothAlert("Resetting State")
        case .unauthorized:
            presentBluetoothAlert("Unauth State")
        case .unknown:
            presentBluetoothAlert("Unknown State")
        case .unsupported:
            centralController.turnOn()
            presentBluetoothAlert("Unsupported State")
        default:
            print("Bluetooth is on")
        }
        return centralController.getState() == CBManagerState.poweredOn

    }

    func centralDidUpdateStateCallback(_ state: CBManagerState) {
        bluetoothDidUpdateStateCallback?(state)
    }

    func toggleAdvertisement(_ state: Bool) {
        if state {
            peripheralController.turnOn()
        } else {
            peripheralController.turnOff()
        }
    }

    func toggleScanning(_ state: Bool) {
        if state {
            centralController.turnOn()
        } else {
            centralController.turnOff()
        }
    }
}
