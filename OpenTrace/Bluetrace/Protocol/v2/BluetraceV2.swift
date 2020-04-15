//
//  BluetraceV2.swift
//  OpenTrace

import Foundation

class BluetraceV2: BluetraceProtocol {

}

let bluetraceV2 = BluetraceV2(versionInt: 2, central: V2Central(), peripheral: V2Peripheral())

class V2Peripheral: PeripheralProtocol {

    let userDefaultsAdvtKey = "ADVT_DATA"
    let userDefaultsAdvtExpiryKey = "ADVT_EXPIRY"

    var advtPayload: Data? {
        return UserDefaults.standard.data(forKey: userDefaultsAdvtKey)
    }

    // This variable stores the expiry date of the broadcast message. At the same time, we will use this expiry date as the expiry date for the encryted advertisement payload
    var advtPayloadExpiry: Date? {
        return UserDefaults.standard.object(forKey: userDefaultsAdvtExpiryKey) as? Date
    }

    func prepareReadRequestData(onComplete: @escaping (Data?) -> Void) {

// Uncomment the code below to be able to debug bluetooth without getting tempIDs from firebase #bluetooth_debug
//        let fakePayload: Data? = Data("Fj5jfbTtDySw8JoVsCmeul0wsoIcJKRPV0HtEFUlNvNg6C3wyGj8R1utPbw+Iz8tqAdpbxR1nSvr+ILXPG--".utf8)
//        onComplete(fakePayload); return
        
        if advtPayloadExpiry == nil ||  Date() > advtPayloadExpiry! {
            EncounterMessageManager.shared.fetchBatchTempIdsFromFirebase {(error: Error?, resp: (tempIds: [[String: Any]], refreshDate: Date)?) in
                guard let response = resp else {
                    Logger.DLog("No response, Error: \(String(describing: error))")
                    onComplete(nil)
                    return
                }
                if let encodedPayload = EncounterMessageManager.shared.setAdvtPayloadIntoUserDefaultsv2(response) {
                    onComplete(encodedPayload)
                }
                onComplete(nil)
            }

        }

        // we know that payload has not expired
        if let payload = advtPayload {
            onComplete(payload)
        } else {
            // this is not part of usual expected flow, just run setup and be done with it
            EncounterMessageManager.shared.setup()
            onComplete(nil)
        }
    }

    func processWriteRequestDataReceived(dataWritten: Data) -> EncounterRecord? {
        do {

            let dataFromCentral = try JSONDecoder().decode(CentralWriteDataV2.self, from: dataWritten)
            let encounter = EncounterRecord(from: dataFromCentral)
            return encounter

        } catch {
            Logger.DLog("Error: \(error). characteristicValue is \(dataWritten)")
        }
        return nil
    }

}

class V2Central: CentralProtocol {
    func prepareWriteRequestData(tempId: String, rssi: Double, txPower: Double?) -> Data? {
        do {
            let dataToWrite = CentralWriteDataV2(
                mc: DeviceInfo.getModel(),
                rs: rssi,
                id: tempId,
                o: BluetraceConfig.OrgID,
                v: BluetraceConfig.ProtocolVersion)

            let encodedData = try JSONEncoder().encode(dataToWrite)

            return encodedData
        } catch {
            Logger.DLog("Error: \(error)")
        }

        return nil
    }

    func processReadRequestDataReceived(scannedPeriEncounter: EncounterRecord, characteristicValue: Data) -> EncounterRecord? {
        do {
            let peripheralCharData = try JSONDecoder().decode(PeripheralCharacteristicsDataV2.self, from: characteristicValue)
            var encounterStruct = scannedPeriEncounter

            encounterStruct.msg = peripheralCharData.id
            encounterStruct.update(modelP: peripheralCharData.mp)
            encounterStruct.org = peripheralCharData.o
            encounterStruct.v = peripheralCharData.v

            return encounterStruct

        } catch {
            Logger.DLog("Error: \(error). characteristicValue is \(characteristicValue)")
        }
        return nil
    }

}
