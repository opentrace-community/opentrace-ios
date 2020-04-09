//
//  Bluetrace.swift
//  OpenTrace

import Foundation

struct Bluetrace {
    static let characteristicToProtocolVersionMap = [
        BluetraceConfig.CharacteristicServiceIDv2.uuidString: 2
    ]

    static var implementations = [
        2: bluetraceV2]

    // gets the protocol implementation via the charUUID map
    // fallbacks to V2
    static func getImplementation(_ charUUID: String) -> BluetraceProtocol {
        if let protocolVersion = Bluetrace.characteristicToProtocolVersionMap[charUUID] {
            return getImplementation(protocolVersion)
        }
        return bluetraceV2
    }

    static func getImplementation(_ protocolVersion: Int) -> BluetraceProtocol {
        if let impl = implementations[protocolVersion] {
            return impl
        }

        return bluetraceV2
    }

}
