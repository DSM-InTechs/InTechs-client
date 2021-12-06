//
//  ChatMessage.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/12/01.
//

import Foundation

public typealias ChatEmojis = [String: MessageEmoji] // 이모지 이름: 이모지

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
    public var threads: [ThreadMessage]
//    public var emojis: [ChatEmojis]
    public var delete: Bool
    
    public init(id: String, message: String, time: String, sender: MessageSender, isMine: Bool?, chatType: String, threads: [ThreadMessage], delete: Bool) {
        self.id = id
        self.message = message
        self.time = time
        self.sender = sender
        self.isMine = isMine
        self.chatType = chatType
        self.threads = threads
//        self.emojis = emojis
        self.delete = delete
    }
    
    public init(dict: [String: Any]) {
        self.id = dict["id"] as? String ?? "오류"
        self.message = dict["message"] as? String ?? "오류"
        self.time = dict["time"] as? String ?? "오류"
        self.sender = MessageSender(dict: dict["sender"] as! [String: Any])
        self.isMine = dict["isMine"] as? Bool ?? false
        self.chatType = dict["chatType"] as? String ?? "오류"
        self.threads = dict["threads"] as? [ThreadMessage] ?? []
//        self.emojis = []
//        print("Emoji = \(dict["emojis"])")
//        for emoji in dict["emojis"] as! [String: [String: Any]] {
//            self.emojis.append([emoji.key: MessageEmoji(dict: emoji.value)])
//        }
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

public struct ThreadMessage: Codable, Hashable, Equatable {
    public var chatId: String?
    public var message: String
    public var sender: MessageSender
    public var time: String
    
    public init(chatId: String?, message: String, sender: MessageSender, time: String) {
        self.chatId = chatId
        self.message = message
        self.sender = sender
        self.time = time
    }
    
    public init(message: String, sender: MessageSender, time: String) {
        self.chatId = nil
        self.message = message
        self.sender = sender
        self.time = time
    }
    
    public init(dict: [String: Any]) {
        self.chatId = dict["chatId"] as? String ?? nil
        self.message = dict["message"] as? String ?? "오류"
        self.sender =  MessageSender(dict: dict["sender"] as! [String: Any])
        self.time = dict["time"] as? String ?? "오류"
    }
}

public struct MessageEmoji: Codable, Hashable, Equatable {
    public var count: Int
    public var users: [MessageSender]
    
    public init(count: Int, users: [MessageSender]) {
        self.count = count
        self.users = users
    }
    
    public init(dict: [String: Any]) {
        self.count = dict["count"] as? Int ?? 0
        self.users = []
        
        for user in dict["users"] as! [[String: Any]] {
            self.users.append(MessageSender(dict: user))
        }
    }
}
