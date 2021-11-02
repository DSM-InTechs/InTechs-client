//
//  CalendarIssue.swift
//  InTechs
//
//  Created by GoEun Jeong on 2021/10/28.
//

import Foundation

public struct CalendarIssue: Codable, Hashable, Equatable {
    public var id: String
    public var writer: String
    public var title: String
    public var content: String?
    public var state: String?
    public var endDate: String?
}
