//
//  Date+Compare.swift
//  InTechs
//
//  Created by GoEun Jeong on 2021/10/22.
//

import Foundation

extension Date {
    static func compareWithToday(a: String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let A: Date? = dateFormatter.date(from: a)
        if A == nil { return -1 }
        switch A!.compare(Date()) {
        case .orderedDescending:
            return 1
        default:
            return 0
        }
    }
}
