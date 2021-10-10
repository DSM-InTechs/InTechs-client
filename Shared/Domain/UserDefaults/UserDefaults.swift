//
//  UserDefaults.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/10/04.
//

import Foundation
import SwiftUI

@propertyWrapper
public struct UserDefault<Value> {
    private let key: String
    private let defaultValue: Value
    private let UD: UserDefaults
    private let lock = NSLock()
    
    public init(key: String, defaultValue: Value, UD: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.UD = UD
    }
    
    public var wrappedValue: Value {
        get {
            lock.withCriticalSection {
                return UD.object(forKey: key) as? Value ?? defaultValue
            }
        }
        set {
            lock.withCriticalSection {
                UD.set(newValue, forKey: key)
            }
        }
    }
}
