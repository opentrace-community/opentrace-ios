//
//  EncounterRecord.swift
//  OpenTrace

import Foundation

struct EncounterRecord: Encodable {
    var timestamp: Date?
    var msg: String?
    var modelC: String?
    private(set) var modelP: String?
    var rssi: Double?
    var txPower: Double?
    var org: String?
    var v: Int?

    mutating func update(msg: String) {
        self.msg = msg
    }

    mutating func update(modelP: String) {
        self.modelP = modelP
    }

    // This initializer is used when central discovered a peripheral, and need to record down the rssi and txpower, and have not yet connected with the peripheral to get the msg
    init(rssi: Double, txPower: Double?) {
        self.timestamp = Date()
        self.msg = nil
        self.modelC = DeviceInfo.getModel()
        self.modelP = nil
        self.rssi = rssi
        self.txPower = txPower
        self.org = nil
        self.v = nil
    }

    init(from centralWriteDataV2: CentralWriteDataV2) {
        self.timestamp = Date()
        self.msg = centralWriteDataV2.id
        self.modelC = centralWriteDataV2.mc
        self.modelP = DeviceInfo.getModel()
        self.rssi = centralWriteDataV2.rs
        self.org = centralWriteDataV2.o
        self.v = centralWriteDataV2.v
    }

    init(msg: String) {
        self.timestamp = Date()
        self.msg = msg
        self.modelC = nil
        self.modelP = nil
        self.rssi = nil
        self.txPower = nil
        self.org = nil
        self.v = nil
    }
}
