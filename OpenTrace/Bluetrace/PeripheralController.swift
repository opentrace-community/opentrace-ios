import CoreBluetooth

public struct PeripheralCharacteristicsDataV2: Codable {
    var mp: String // phone model of peripheral
    var id: String // tempID
    var o: String // organisation
    var v: Int // protocol version
}

public class PeripheralController: NSObject {

    enum PeripheralError: Error {
        case peripheralAlreadyOn
        case peripheralAlreadyOff
    }

    var didUpdateState: ((String) -> Void)?
    private let restoreIdentifierKey = "com.opentrace.peripheral"
    private let peripheralName: String

    private var characteristicDataV2: PeripheralCharacteristicsDataV2

    private var peripheral: CBPeripheralManager!
    private var queue: DispatchQueue

    // Protocol v2 - CharacteristicServiceIDv2
    private lazy var readableCharacteristicV2 = CBMutableCharacteristic(type: BluetraceConfig.CharacteristicServiceIDv2, properties: [.read, .write, .writeWithoutResponse], value: nil, permissions: [.readable, .writeable])

    public init(peripheralName: String, queue: DispatchQueue) {
        Logger.DLog("PC init")
        self.queue = queue
        self.peripheralName = peripheralName

        self.characteristicDataV2 = PeripheralCharacteristicsDataV2(mp: DeviceInfo.getModel(), id: "<unknown>", o: BluetraceConfig.OrgID, v: BluetraceConfig.ProtocolVersion)

        super.init()
    }

    public func turnOn() {
        guard peripheral == nil else {
            return
        }
        peripheral = CBPeripheralManager(delegate: self, queue: self.queue, options: [CBPeripheralManagerOptionRestoreIdentifierKey: restoreIdentifierKey])
    }

    public func turnOff() {
        guard peripheral != nil else {
            return
        }
        peripheral.stopAdvertising()
        peripheral = nil
    }

    public func getState() -> CBManagerState {
        return peripheral.state
    }
}

extension PeripheralController: CBPeripheralManagerDelegate {

    public func peripheralManager(_ peripheral: CBPeripheralManager,
                                  willRestoreState dict: [String: Any]) {
        Logger.DLog("PC willRestoreState")
    }

    public func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        Logger.DLog("PC peripheralManagerDidUpdateState. Current state: \(BluetraceUtils.managerStateToString(peripheral.state))")
        didUpdateState?(BluetraceUtils.managerStateToString(peripheral.state))
        guard peripheral.state == .poweredOn else { return }
        let advertisementData: [String: Any] = [CBAdvertisementDataLocalNameKey: peripheralName,
                                                CBAdvertisementDataServiceUUIDsKey: [BluetraceConfig.BluetoothServiceID]]

        let tracerService = CBMutableService(type: BluetraceConfig.BluetoothServiceID, primary: true)

        tracerService.characteristics = [readableCharacteristicV2]

        peripheral.removeAllServices()

        peripheral.add(tracerService)
        peripheral.startAdvertising(advertisementData)
    }

    public func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        Logger.DLog("\(["request": request] as AnyObject)")

        let bluetraceImplementation = Bluetrace.getImplementation(request.characteristic.uuid.uuidString)

        bluetraceImplementation.peripheral.prepareReadRequestData {
            (payload) in
            if let payload = payload {
                Logger.DLog("Success - getting payload")
                request.value = payload
                peripheral.respond(to: request, withResult: .success)
            } else {
                Logger.DLog("Error - getting payload")
                peripheral.respond(to: request, withResult: .unlikelyError)
            }
        }

    }

    public func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        let debugLogs = ["requests": requests as AnyObject,
                         "reqValue": String(data: requests[0].value!, encoding: .utf8) ?? "<nil>"] as AnyObject
        Logger.DLog("\(debugLogs)")
        for request in requests {
            if let receivedCharacteristicValue = request.value {
                let bluetraceImplementation = Bluetrace.getImplementation(request.characteristic.uuid.uuidString)

                guard let encounter = bluetraceImplementation.peripheral.processWriteRequestDataReceived(dataWritten: receivedCharacteristicValue) else { return }

                encounter.saveToCoreData()

            }
        }
        peripheral.respond(to: requests[0], withResult: .success)

    }
}
