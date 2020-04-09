import Foundation
import FirebaseFunctions

struct FirebaseAPIs {
    static var functions = Functions.functions(region: "asia-east2")

    static func getHandshakePin(_ onComplete: @escaping (String?) -> Void) {
        functions.httpsCallable("getHandshakePin").call { (resp, error) in
            guard error == nil else {
                if let error = error as NSError? {
                    if error.domain == FunctionsErrorDomain {
                        let code = FunctionsErrorCode(rawValue: error.code)
                        let message = error.localizedDescription
                        let details = error.userInfo[FunctionsErrorDetailsKey]
                        Logger.DLog("Cloud function error. Code: \(String(describing: code)), Message: \(message), Details: \(String(describing: details))")
                        onComplete(nil)
                        return
                    }
                } else {
                    Logger.DLog("Cloud function error, unable to convert error to NSError.\(error!)")
                }
                onComplete(nil)
                return
            }
            guard let pin = (resp?.data as? [String: Any])?["pin"] as? String else {
                onComplete(nil)
                return
            }
            onComplete(pin)
        }
    }
}
