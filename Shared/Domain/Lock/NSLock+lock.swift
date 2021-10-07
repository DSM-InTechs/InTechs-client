//
//  lockWithCriticalSection.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/10/05.
//

import Foundation

public extension NSLocking {
    func withCriticalSection<T>(block: () throws -> T) rethrows -> T {
        lock()
        defer { unlock() }
        return try block()
    }
}
