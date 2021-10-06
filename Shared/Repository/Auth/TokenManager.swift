//
//  TokenManager.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/10/05.
//
// CryptoKit - https://xodhks0113.blogspot.com/2021/05/ios-cryptokit-sha512-salt.html?utm_source=feedburner&utm_medium=feed&utm_campaign=Feed:+blogspot/YEeSL+(%EB%AC%BC%EB%A8%B9%EA%B3%A0%ED%95%98%EC%9E%90%EC%9D%98+%EB%B8%94%EB%A1%9C%EA%B7%B8)&m=1

import Foundation
import CryptoKit

final public class TokenManager {
    private static let bundleID = Bundle.main.bundleIdentifier!
    private static let UD = UserDefaults.standard
    private static let lock = NSLock()
    
    public static var accessToken: String? {
        get {
            lock.withCriticalSection {
                return UD.string(forKey: "accessToken")
            }
        }
        set {
            lock.withCriticalSection {
                UD.set(newValue, forKey: "accessToken")
            }
        }
    }
    
    public static var refreshToken: String? {
        get {
            lock.withCriticalSection {
                return UD.string(forKey: "accessToken")
            }
        }
        set {
            lock.withCriticalSection {
                UD.set(newValue, forKey: "accessToken")
            }
        }
    }
    
    public static var email: String? {
        get {
            lock.withCriticalSection {
                guard let email = UD.string(forKey: "email") else {
                    return nil
                }
                
                let str = bundleID + email
                
//                let data = str.data(using: .utf8)!
//                let sha256 = SHA256.hash(data: data)
//                let hashString = sha256.compactMap { String(format: "%02x", $0) }.joined()
                
                return "hashString"
            }
        }
        set {
            lock.withCriticalSection {
                guard let email = newValue else {
                    return
                }
                
                let str = bundleID + email
//                let data = str.data(using: .utf8)!
//                let sha256 = SHA256.hash(data: data)
//
//                var shaData = Data()
//                sha256.compactMap { shaData.append($0) }
//                
//                let sha256Base64String = shaData.base64EncodedString()
//                UD.set(sha256Base64String, forKey: "email")
            }
        }
    }
}
