#!/usr/bin/env xcrun swift
// vi: ft=swift

import AppKit
import CoreWLAN
import Foundation
import Security

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
    if #available(OSX 10.10, *) {
        return CWWiFiClient.shared().interface()?.ssid()
    }
    return nil
}

func getPasswd(userAccount: String) -> String? {
    let keychainQuery: NSMutableDictionary = NSMutableDictionary(
        objects: [kSecClassGenericPasswordValue,
                  kAirPortService,
                  userAccount,
                  kCFBooleanTrue,
                  kSecMatchLimitOneValue],
        forKeys: [kSecClassValue,
                  kSecAttrServiceValue,
                  kSecAttrAccountValue,
                  kSecReturnDataValue,
                  kSecMatchLimitValue])

    var dataTypeRef: AnyObject?
    SecItemCopyMatching(keychainQuery, &dataTypeRef)

    if let retrievedData = dataTypeRef as? NSData {
        if let string = NSString(data:retrievedData as Data,
                                 encoding:String.Encoding.utf8.rawValue) {
            return string as String
        }
    }

    return nil
}

func main() -> Int32 {
    let args = CommandLine.arguments

    var ssid: String?
    if args.count > 1 {
        ssid = args[1]
    } else {
        ssid = getCurrentSsid()
    }

    if let s = ssid {
        if let pass = getPasswd(userAccount: s) {
            // Copy to clipboard
            let pb = NSPasteboard.general()
            pb.clearContents()
            pb.setString(pass, forType:NSStringPboardType)

            print("SSID: \(s)")
            print("PASS: \(pass)")

            return 0
        } else {
            print("No WiFi password found for \(s)")
            return 1
        }
    }

    print("No wireless interface detected")
    return 1
}

exit(main())
