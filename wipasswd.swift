#!/usr/bin/env xcrun swift -target x86_64-apple-macosx10.10
// vi: ft=swift

import Security
import Foundation
import CoreWLAN

func getCurrentSsid() -> String? {
    return CWWiFiClient.shared().interface()?.ssid()
}

func getPasswd(ssid: String) -> String? {
    let query: [NSString: Any] = [
        kSecClass: kSecClassGenericPassword,
        kSecAttrService: "AirPort",
        kSecAttrAccount: ssid,
        kSecReturnData: true,
        kSecMatchLimit: kSecMatchLimitOne
    ]
    var result: AnyObject?
    let status = SecItemCopyMatching(query as CFDictionary, &result)
    if status == noErr, let data = result as? Data {
        return String(data: data, encoding: .utf8)
    }
    return nil
}

func main() -> Int32 {
    let args = CommandLine.arguments

    var ssid: String?
    var onlyPasswd = false
    if args.count > 1 {
        if args[1] == "-w" {
            onlyPasswd = true
        }
    }
    if args.count > 2 {
        if onlyPasswd {
            ssid = args[2]
        } else {
            ssid = args[1]
        }
    } else {
        ssid = getCurrentSsid()
    }

    if let s = ssid {
        if let pass = getPasswd(ssid: s) {
            if onlyPasswd {
                print(pass)
            } else {
                print("SSID: \(s)")
                print("PASS: \(pass)")
            }
            return 0
        } else {
            print("No WiFi password found for \(s)")
            return 1
        }
    }
    return 0
}

exit(main())
