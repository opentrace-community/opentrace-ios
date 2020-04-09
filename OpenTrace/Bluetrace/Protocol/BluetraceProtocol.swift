//
//  BluetraceProtocol.swift
//  OpenTrace

import Foundation

class BluetraceProtocol {
    let versionInt: Int
    let central: CentralProtocol
    let peripheral: PeripheralProtocol

    init(versionInt: Int, central: CentralProtocol, peripheral: PeripheralProtocol) {
        self.versionInt = versionInt
        self.central = central
        self.peripheral = peripheral
    }
}

protocol PeripheralProtocol {
    func prepareReadRequestData(onComplete: @escaping (Data?) -> Void)

    func processWriteRequestDataReceived(dataWritten: Data) -> EncounterRecord?
}

protocol CentralProtocol {
    func prepareWriteRequestData(tempId: String, rssi: Double, txPower: Double?) -> Data?
    func processReadRequestDataReceived(scannedPeriEncounter: EncounterRecord, characteristicValue: Data) -> EncounterRecord?
}
