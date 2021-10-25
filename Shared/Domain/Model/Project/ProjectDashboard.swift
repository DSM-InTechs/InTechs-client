//
//  ProjectDashboard.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/10/21.
//

import Foundation

public struct ProjectDashboard: Codable, Hashable, Equatable {
    public var userCount: Int
    public var issuesCount: DashboardIssueCount
}

public struct DashboardIssueCount: Codable, Hashable, Equatable {
    public var forMe: Int
    public var resolved: Int
    public var unresolved: Int
    public var forMeAndUnresolved: Int
}
