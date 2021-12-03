//
//  String+lastPathComponent.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/11/25.
//

import Foundation

extension String {
    var lastPathComponent: String {
        get {
            return (self as NSString).lastPathComponent
        }
    }
}
