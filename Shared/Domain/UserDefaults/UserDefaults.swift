//
//  UserDefaults.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/10/04.
//

import Foundation
import SwiftUI

@propertyWrapper
struct UserDefault<Value> {
    let key: String
    let defaultValue: Value
    var container: UserDefaults = .standard

    var wrappedValue: Value {
        get {
            return container.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            container.set(newValue, forKey: key)
        }
    }
}
