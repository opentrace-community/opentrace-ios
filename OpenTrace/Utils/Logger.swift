//
//  Logger.swift
//  OpenTrace

import Foundation

class Logger {

    static func DLog(_ message: String, file: NSString = #file, line: Int = #line, functionName: String = #function) {
        #if DEBUG
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS "
        print("[\(formatter.string(from: Date()))][\(file.lastPathComponent):\(line)][\(functionName)]: \(message)")
        #endif
    }

}
