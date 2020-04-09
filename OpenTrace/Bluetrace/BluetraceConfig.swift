//
//  BluetraceConfig.swift
//  OpenTrace

import CoreBluetooth

import Foundation

struct BluetraceConfig {
    
    // To obtain the official BlueTrace Service ID and Characteristic ID, please email info@bluetrace.io
    static let BluetoothServiceID = CBUUID(string: "\(PlistHelper.getvalueFromInfoPlist(withKey: "TRACER_SVC_ID") ?? "A6BA4286-C550-4794-A888-9467EF0B31A8")")

    // Staging and Prod uses the same CharacteristicServiceIDv2, since BluetoothServiceID is different
    static let CharacteristicServiceIDv2 = CBUUID(string: "\(PlistHelper.getvalueFromInfoPlist(withKey: "V2_CHARACTERISTIC_ID") ?? "D1034710-B11E-42F2-BCA3-F481177D5BB2")")

    static let charUUIDArray = [CharacteristicServiceIDv2]

    static let OrgID = "OT_HA"
    static let ProtocolVersion = 2

    static let CentralScanInterval = 60 // in seconds
    static let CentralScanDuration = 10 // in seconds

    static let TTLDays = -21
}
