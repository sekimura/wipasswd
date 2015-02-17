#!/usr/bin/env xcrun swift
// vi: ft=swift

import Security
import Foundation

// Arguments for the keychain queries
let kSecClassValue = kSecClass as NSString
let kSecAttrServiceValue = kSecAttrService as NSString
let kSecAttrAccountValue = kSecAttrAccount as NSString
let kSecClassGenericPasswordValue = kSecClassGenericPassword as NSString
let kSecMatchLimitValue = kSecMatchLimit as NSString
let kSecReturnDataValue = kSecReturnData as NSString
let kSecMatchLimitOneValue = kSecMatchLimitOne as NSString
let kAirPortService = "AirPort"


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

    if args.count < 2 {
        println("\n".join([
            "",
            "Usage:",
            "    \(args[0]) 2WIRE199",
            "    \(args[0]) NETGEAR99",
            "",
            ]))
        return
    }

    let ssid = args[1]
    let contentsOfKeychain = getPasswd(ssid)
    if let pass = contentsOfKeychain? {
        println("SSID: \(ssid)")
        println("PASS: \(pass)")
    } else {
        println("No WiFi password found for \(ssid)")
    }
}

main()