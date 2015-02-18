#!/usr/bin/env xcrun swift
// vi: ft=swift

import Security
import Foundation
import SystemConfiguration.CaptiveNetwork

// Arguments for the keychain queries
let kSecClassValue = kSecClass as NSString
let kSecAttrServiceValue = kSecAttrService as NSString
let kSecAttrAccountValue = kSecAttrAccount as NSString
let kSecClassGenericPasswordValue = kSecClassGenericPassword as NSString
let kSecMatchLimitValue = kSecMatchLimit as NSString
let kSecReturnDataValue = kSecReturnData as NSString
let kSecMatchLimitOneValue = kSecMatchLimitOne as NSString
let kAirPortService = "AirPort"

func getCurrentSsid() -> String? {
    // TODO(sekimura): fixme
    let task = NSTask()
    task.launchPath = "/bin/sh"
    task.arguments = [
        "-c",
        "/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport -I| grep ' SSID:'| sed -e 's/^ *SSID: //'"]

    let pipe = NSPipe()
    task.standardOutput = pipe
    task.launch()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let str = NSString(data:data, encoding:NSUTF8StringEncoding)
    if let s = str? {
        return s.stringByReplacingOccurrencesOfString("\n", withString:"")
    } else {
        return nil
    }
}

func getPasswd(userAccount : String) -> String? {
    var keychainQuery: NSMutableDictionary = NSMutableDictionary(
        objects: [kSecClassGenericPasswordValue, kAirPortService, userAccount, kCFBooleanTrue, kSecMatchLimitOneValue],
        forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue])

    var dataTypeRef: Unmanaged<AnyObject>?

    let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)

    let opaque = dataTypeRef?.toOpaque()
    if let op = opaque? {
        let retrievedData = Unmanaged<NSData>.fromOpaque(op).takeUnretainedValue()
        return NSString(data:retrievedData, encoding:NSUTF8StringEncoding) as NSString?
    } else {
        return nil
    }
}

func main() {
    let args = [String](Process.arguments)


    var ssid: String?
    if args.count > 1 {
        ssid = args[1]
    } else {
        ssid = getCurrentSsid()
    }

    if let s = ssid? {
        let contentsOfKeychain = getPasswd(s)
        if let pass = contentsOfKeychain? {
            println("SSID: \(s)")
            println("PASS: \(pass)")
        } else {
            println("No WiFi password found for \(s)")
        }
    }
}

main()
