//
//  Date+year.swift
//  InTechs
//
//  Created by GoEun Jeong on 2021/10/27.
//

import Foundation

extension Date {
    var year: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: self)
    }
}
