#!/usr/bin/env xcrun swift
// vi: ft=swift

import Security
import Foundation
import CoreWLAN

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
    return CWWiFiClient.sharedWiFiClient().interface().ssid()
}

func getPasswd(userAccount : String) -> String? {
    var keychainQuery: NSMutableDictionary = NSMutableDictionary(
        objects: [kSecClassGenericPasswordValue, kAirPortService, userAccount, kCFBooleanTrue, kSecMatchLimitOneValue],
        forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue])

    var dataTypeRef: Unmanaged<AnyObject>?

    let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)

    let opaque = dataTypeRef?.toOpaque()
    if let op = opaque {
        let retrievedData = Unmanaged<NSData>.fromOpaque(op).takeUnretainedValue()
        if let string = NSString(data:retrievedData, encoding:NSUTF8StringEncoding) {
            return string as String
        } else {
            return nil
        }
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

    if let s = ssid {
        let contentsOfKeychain = getPasswd(s)
        if let pass = contentsOfKeychain {
            println("SSID: \(s)")
            println("PASS: \(pass)")
            exit(1)
        } else {
            println("No WiFi password found for \(s)")
            exit(0)
        }
    } else {
        println("No wireless interface detected")
        exit(0)
    }
}

main()
