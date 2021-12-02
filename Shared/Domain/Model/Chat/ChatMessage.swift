//
//  ChatMessage.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/12/01.
//

import Foundation

public struct MessageList: Codable, Hashable, Equatable {
    public var channelId: String
    public var notice: ChatMessage?
    public var chats: [ChatMessage]
}

public struct ChatMessage: Codable, Hashable, Equatable {
    public var id: String
    public var message: String
    public var time: String
    public var sender: MessageSender
    public var isMine: Bool?
    public var chatType: String
    public var delete: Bool
}

public struct MessageSender: Codable, Hashable, Equatable {
    public var name: String
    public var email: String
    public var imageURL: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case imageURL = "image"
    }
}
