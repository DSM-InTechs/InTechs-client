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
    
    public init(id: String, message: String, time: String, sender: MessageSender, isMine: Bool?, chatType: String, delete: Bool) {
        self.id = id
        self.message = message
        self.time = time
        self.sender = sender
        self.isMine = isMine
        self.chatType = chatType
        self.delete = delete
    }
    
    public init(dict: [String: Any]) {
        self.id = dict["id"] as? String ?? "오류"
        self.message = dict["message"] as? String ?? "오류"
        self.time = dict["time"] as? String ?? "오류"
        self.sender = MessageSender(dict: dict["sender"] as! [String : Any])
        self.isMine = dict["isMine"] as? Bool ?? false
        self.chatType = dict["chatType"] as? String ?? "오류"
        self.delete = dict["isDelete"] as? Bool ?? false
    }
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
    
    public init(name: String, email: String, imageURL: String) {
        self.name = name
        self.email = email
        self.imageURL = imageURL
    }
    
    public init(dict: [String: Any]) {
        self.name = dict["name"] as? String ?? "오류"
        self.email = dict["email"] as? String ?? "오류"
        self.imageURL = dict["image"] as? String ?? "오류"
    }
}
