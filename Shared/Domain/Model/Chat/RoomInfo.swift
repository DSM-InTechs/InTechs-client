//
//  RoomInfo.swift
//  InTechs
//
//  Created by GoEun Jeong on 2021/12/02.
//

import Foundation

public struct RoomInfo: Codable, Hashable, Equatable {
    public var id: String
    public var name: String
    public var image: String
    public var users: [RoomUser]
    public var notification: Bool
    public var dm: Bool
}

public struct RoomUser: Codable, Hashable, Equatable {
    public var name: String
    public var email: String
    public var imageURL: String
    public var isActive: Bool
    
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case imageURL = "image"
        case isActive = "active"
    }
}
