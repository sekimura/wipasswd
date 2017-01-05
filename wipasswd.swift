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

@available(OSX 10.10, *)
func getCurrentSsid() -> String? {
    return CWWiFiClient.shared().interface()?.ssid()
}

@available(OSX 10.10, *)
func getPasswd(userAccount : String) -> String? {
    let keychainQuery: NSMutableDictionary = NSMutableDictionary(
        objects: [kSecClassGenericPasswordValue, kAirPortService, userAccount, kCFBooleanTrue, kSecMatchLimitOneValue],
        forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue])

    var dataTypeRef: AnyObject?
    SecItemCopyMatching(keychainQuery, &dataTypeRef)

    if let retrievedData = dataTypeRef as? NSData {
        if let string = NSString(data:retrievedData as Data, encoding:String.Encoding.utf8.rawValue) {
            return string as String
        } else {
            return nil
        }
    }

    return nil
}

func main() {
    let args = CommandLine.arguments

    var ssid: String?
    if args.count > 1 {
        ssid = args[1]
    } else {
        if #available(OSX 10.10, *) {
            ssid = getCurrentSsid()
        } else {
            exit(1)
        }
    }

    let contentsOfKeychain: String?

    if let s = ssid {
        if #available(OSX 10.10, *) {
            contentsOfKeychain = getPasswd(userAccount: s)
        } else {
            exit(1)
        }

        if let pass = contentsOfKeychain {
            print("SSID: \(s)")
            print("PASS: \(pass)")
            exit(1)
        } else {
            print("No WiFi password found for \(s)")
            exit(0)
        }
    } else {
        print("No wireless interface detected")
        exit(0)
    }
}

main()
