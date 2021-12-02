//
//  ChatRoom.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/12/01.
//

import Foundation

public struct ChatRoom: Codable, Hashable, Equatable {
    public var id: String
    public var name: String
    public var imageURL: String
    public var message: String
    public var time: String
    public var isDM: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageURL = "image"
        case message
        case time
        case isDM = "dm"
    }
}
