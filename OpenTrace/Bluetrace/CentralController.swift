//
//  CentralController.swift
//  OpenTrace

import Foundation
import CoreData
import CoreBluetooth
import UIKit

struct CentralWriteDataV2: Codable {
    var mc: String // phone model of central
    var rs: Double // rssi
    var id: String // tempID
    var o: String // organisation
    var v: Int // protocol version
}

class CentralController: NSObject {
    enum CentralError: Error {
        case centralAlreadyOn
        case centralAlreadyOff
    }
    var centralDidUpdateStateCallback: ((CBManagerState) -> Void)?
    var characteristicDidReadValue: ((EncounterRecord) -> Void)?
    private let restoreIdentifierKey = "com.opentrace.central"
    private var central: CBCentralManager?
    private var recoveredPeripherals: [CBPeripheral] = []
    private var queue: DispatchQueue

    // This dict keeps track of discovered android devices, so that we do not connect to the same Android device multiple times within the same BluetraceConfig.CentralScanInterval. Our Android code sets a Manufacturer field for this purpose.
    private var discoveredAndroidPeriManufacturerToUUIDMap = [Data: UUID]()

    // This dict has 2 purposes:
    // 1. Stores all the EncounterRecords, because the RSSI and TxPower is obtained at the didDiscoverPeripheral delegate, but characterstic value is obtained at didUpdateValueForCharacteristic delegate
    // 2. Used to check for duplicated iphones peripheral being discovered, so that we dont connect to the same iphone again in the same scan window
    private var scannedPeripherals = [UUID: (peripheral: CBPeripheral, encounter: EncounterRecord)]() // stores the peripherals encountered within one scan interval
    var timerForScanning: Timer?

    public init(queue: DispatchQueue) {
        self.queue = queue
        super.init()
    }

    func turnOn() {
        Logger.DLog("CC requested to be turnOn")
        guard central == nil else {
            return
        }
        central = CBCentralManager(delegate: self, queue: self.queue, options: [CBCentralManagerOptionRestoreIdentifierKey: restoreIdentifierKey])
    }

    func turnOff() {
        Logger.DLog("CC turnOff")
        guard central != nil else {
            return
        }
        central?.stopScan()
        central = nil
    }

    public func getState() -> CBManagerState? {
        return central?.state
    }
}

extension CentralController: CBCentralManagerDelegate {

    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String: Any]) {
        // This code handles iOS background state restoration
        //        Logger.DLog("CC willRestoreState. Central state: \(managerStateToString(central?.state))")
        //        if let peripheralsObject = dict[CBCentralManagerRestoredStatePeripheralsKey] {
        //            let peripherals = peripheralsObject as! `Array`<CBPeripheral>
        //            Logger.DLog("CC restoring \(peripherals.count) peripherals from system.")
        //            for peripheral in peripherals {
        //                recoveredPeripherals.append(peripheral)
        //                peripheral.delegate = self
        //                peripheral.readRSSI()
        //            }
        //        }
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        centralDidUpdateStateCallback?(central.state)
        switch central.state {
        case .poweredOn:
            DispatchQueue.main.async {
                self.timerForScanning = Timer.scheduledTimer(withTimeInterval: TimeInterval(BluetraceConfig.CentralScanInterval), repeats: true) { _ in
                    Logger.DLog("CC Starting a scan")
                    Encounter.saveWithCurrentTime(for: .scanningStarted)

                    // For all peripherals that are not disconnected, disconnect them
                    self.scannedPeripherals.forEach { (scannedPeri) in
                        central.cancelPeripheralConnection(scannedPeri.value.peripheral)
                    }
                    // Clear all peripherals, such that a new scan window can take place
                    self.scannedPeripherals = [UUID: (CBPeripheral, EncounterRecord)]()
                    self.discoveredAndroidPeriManufacturerToUUIDMap = [Data: UUID]()

                    // Using Service ID
                    central.scanForPeripherals(withServices: [BluetraceConfig.BluetoothServiceID])
                    DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(BluetraceConfig.CentralScanDuration)) {
                        Logger.DLog("CC Stopping a scan")
                        central.stopScan()
                        Encounter.saveWithCurrentTime(for: .scanningStopped)
                    }
                }
                self.timerForScanning?.fire()
            }
        default:
            timerForScanning?.invalidate()
        }

        // This code handles iOS background state restoration
        //        for recoveredPeripheral in recoveredPeripherals {
        //            if (!discoveredPeripherals.contains(recoveredPeripheral)) {
        //                discoveredPeripherals.append(recoveredPeripheral)
        //                recoveredPeripheral.delegate = self
        //                handlePeripheralOfUncertainStatus(recoveredPeripheral)
        //            }
        //        }
    }

    func handlePeripheralOfUncertainStatus(_ peripheral: CBPeripheral) {
        // If not connected to Peripheral, attempt connection and exit
        if peripheral.state != .connected {
            Logger.DLog("CC handlePeripheralOfUncertainStatus not connected")
            central?.connect(peripheral)
            return
        }
        // If don't know about Peripheral's services, discover services and exit
        if peripheral.services == nil {
            Logger.DLog("CC handlePeripheralOfUncertainStatus unknown services")
            peripheral.discoverServices([BluetraceConfig.BluetoothServiceID])
            return
        }
        // If Peripheral's services don't contain targetID, disconnect and remove, then exit.
        // If it does contain targetID, discover characteristics for service
        guard let service = peripheral.services?.first(where: { $0.uuid == BluetraceConfig.BluetoothServiceID }) else {
            Logger.DLog("CC handlePeripheralOfUncertainStatus no matching Services")
            central?.cancelPeripheralConnection(peripheral)
            return
        }
        Logger.DLog("CC handlePeripheralOfUncertainStatus discoverCharacteristics")
        peripheral.discoverCharacteristics([BluetraceConfig.BluetoothServiceID], for: service)
        // If Peripheral's service's characteristics don't contain targetID, disconnect and remove, then exit.
        // If it does contain targetID, read value for characteristic
        guard let characteristic = service.characteristics?.first(where: { $0.uuid == BluetraceConfig.BluetoothServiceID}) else {
            Logger.DLog("CC handlePeripheralOfUncertainStatus no matching Characteristics")
            central?.cancelPeripheralConnection(peripheral)
            return
        }
        Logger.DLog("CC handlePeripheralOfUncertainStatus readValue")
        peripheral.readValue(for: characteristic)
        return
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        let debugLogs = ["CentralState": BluetraceUtils.managerStateToString(central.state),
                         "peripheral": peripheral,
                         "advertisments": advertisementData as AnyObject] as AnyObject

        Logger.DLog("\(debugLogs)")

        // iphones will "mask" the peripheral's identifier for android devices, resulting in the same android device being discovered multiple times with different peripheral identifier. Hence android is using CBAdvertisementDataServiceDataKey data for identifying an android pheripheral
        if let manuData = advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data {
            let androidIdentifierData = manuData.subdata(in: 2..<manuData.count)
            if discoveredAndroidPeriManufacturerToUUIDMap.keys.contains(androidIdentifierData) {
                Logger.DLog("Android Peripheral \(peripheral) has been discovered already in this window, will not attempt to connect to it again")
                return
            } else {
                peripheral.delegate = self
                discoveredAndroidPeriManufacturerToUUIDMap.updateValue(peripheral.identifier, forKey: androidIdentifierData)
                scannedPeripherals.updateValue((peripheral, EncounterRecord(rssi: RSSI.doubleValue, txPower: advertisementData[CBAdvertisementDataTxPowerLevelKey] as? Double)), forKey: peripheral.identifier)
                central.connect(peripheral)
            }
        } else {
            // Means this is not an android device. We check if the peripheral.identifier exist in the scannedPeripherals
            Logger.DLog("CBAdvertisementDataManufacturerDataKey Data not found. Peripheral is likely not android")
            if scannedPeripherals[peripheral.identifier] == nil {
                peripheral.delegate = self
                scannedPeripherals.updateValue((peripheral, EncounterRecord(rssi: RSSI.doubleValue, txPower: advertisementData[CBAdvertisementDataTxPowerLevelKey] as? Double)), forKey: peripheral.identifier)
                central.connect(peripheral)
            } else {
                Logger.DLog("iOS Peripheral \(peripheral) has been discovered already in this window, will not attempt to connect to it again")
            }
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        let peripheralStateString = BluetraceUtils.peripheralStateToString(peripheral.state)
        Logger.DLog("CC didConnect peripheral peripheralCentral state: \(BluetraceUtils.managerStateToString(central.state)), Peripheral state: \(peripheralStateString)")
        peripheral.delegate = self
        peripheral.discoverServices([BluetraceConfig.BluetoothServiceID])
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        Logger.DLog("CC didDisconnectPeripheral \(peripheral) , \(error != nil ? "error: \(error.debugDescription)" : "" )")
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        Logger.DLog("CC didFailToConnect peripheral \(error != nil ? "error: \(error.debugDescription)" : "" )")
    }
}

extension CentralController: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let err = error {
            Logger.DLog("error: \(err)")
        }
        guard let service = peripheral.services?.first(where: { $0.uuid == BluetraceConfig.BluetoothServiceID }) else { return }

        peripheral.discoverCharacteristics([BluetraceConfig.CharacteristicServiceIDv2], for: service)

    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let err = error {
            Logger.DLog("error: \(err)")
        }

        guard let characteristic = service.characteristics?.first(where: { $0.uuid == BluetraceConfig.CharacteristicServiceIDv2}) else { return }

        peripheral.readValue(for: characteristic)

        // Do not need to wait for a successful read before writing, because no data from the read is needed in the write
        if let currEncounter = scannedPeripherals[peripheral.identifier] {
            EncounterMessageManager.shared.getTempId { (result) in
                guard let tempId = result else {
                    Logger.DLog("broadcast msg not present")
                    return
                }
                guard let rssi = currEncounter.encounter.rssi else {
                    Logger.DLog("rssi should be present in \(currEncounter.encounter)")
                    return
                }
                let bluetraceImplementation = Bluetrace.getImplementation(characteristic.uuid.uuidString)

                guard let encodedData = bluetraceImplementation.central.prepareWriteRequestData(tempId: tempId, rssi: rssi, txPower: currEncounter.encounter.txPower) else {
                    return
                }
                peripheral.writeValue(encodedData, for: characteristic, type: .withResponse)

            }
        }

    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        let debugLogs = ["characteristic": characteristic as AnyObject,
                         "encounter": scannedPeripherals[peripheral.identifier] as AnyObject] as AnyObject

        Logger.DLog("\(debugLogs)")
        if error == nil {
            if let scannedPeri = scannedPeripherals[peripheral.identifier],
                let receivedCharacteristicValue = characteristic.value {
                let bluetraceImplementation = Bluetrace.getImplementation(characteristic.uuid.uuidString)

                guard let encounterStruct = bluetraceImplementation.central.processReadRequestDataReceived(scannedPeriEncounter: scannedPeri.encounter, characteristicValue: receivedCharacteristicValue) else {
                    return
                }

                scannedPeripherals.updateValue((scannedPeri.peripheral, encounterStruct), forKey: peripheral.identifier)
                encounterStruct.saveToCoreData()

            } else {
                Logger.DLog("Error: scannedPeripherals[peripheral.identifier] is \(String(describing: scannedPeripherals[peripheral.identifier])), characteristic.value is \(String(describing: characteristic.value))")
            }
        } else {
            Logger.DLog("Error: \(error!)")
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        Logger.DLog("didWriteValueFor to peripheral: \(peripheral), for characteristics: \(characteristic). \(error != nil ? "error: \(error.debugDescription)" : "" )")
        central?.cancelPeripheralConnection(peripheral)
    }
}
