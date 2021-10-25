//
//  Issue.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/10/20.
//

import Foundation

public struct Issue: Codable, Hashable, Equatable {
    public var id: String
    public var writer: String
    public var title: String
    public var content: String?
    public var state: String?
    public var progress: Int?
    public var endDate: String?
    public var projectId: Int
    public var users: [IssueUser]
    public var tags: [IssueTag]
    public var comments: [IssueComment]?
}

public enum IssueState: String {
    case ready = "READY"
    case progress = "IN_PROGRESS"
    case done = "DONE"
}

public struct IssueUser: Codable, Hashable, Equatable {
    public var name: String
    public var email: String
    public var imageURL: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case imageURL = "image"
    }
}

public struct IssueTag: Codable, Hashable, Equatable {
    public var tag: String
}

public struct IssueComment: Codable, Hashable, Equatable {
    public var id: String
    public var user: IssueUser
    public var content: String
    public var createAt: String
}
