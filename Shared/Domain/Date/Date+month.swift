//
//  Date+month.swift
//  InTechs
//
//  Created by GoEun Jeong on 2021/10/27.
//

import Foundation

extension Date {
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        return dateFormatter.string(from: self)
    }
}
