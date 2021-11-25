//
//  Message.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/22.
//

import Foundation

enum MessageType: String {
    case enter = "ENTER"
    case talk = "TALK"
    case exit = "EXIT"
    case file = "FILE"
    case image = "IMAGE"
}

struct Message: Identifiable, Equatable {
    static func == (lhs: Message, rhs: Message) -> Bool {
        if lhs.id == rhs.id {
            return true
        } else {
            return false
        }
    }
    
    var id = UUID().uuidString
    var type: String
    var message: String
    var isMine: Bool
    var sender: User
    var time: String
    var isThread: Bool
    var threadMessages: [Message]
    var emoticons: [String: Int]
    
    init(message: String, type: String, isMine: Bool, sender: User, time: String, isThread: Bool = false, threadMessages: [Message] = [], emoticons: [String: Int] = [:]) {
        self.message = message
        self.type = type
        self.isMine = isMine
        self.sender = sender
        self.time = time
        self.isThread = isThread
        self.threadMessages = threadMessages
        self.emoticons = emoticons
    }
}

var user1 = User(name: "정고은", email: "gogo8272@gmail.com", imageURL: "https://avatars.githubusercontent.com/u/47523862?v=4", isActive: false)
var user2 = User(name: "이종은", email: "jongeun@gmail.com", imageURL: "https://avatars.githubusercontent.com/u/66874658?v=4", isActive: true)
var user3 = User(name: "임서영", email: "dlatjdud@gmail.com", imageURL: "https://avatars.githubusercontent.com/u/66578746?v=4", isActive: false)

var thread1 = Message(message: "네 좋아용", type: "TALK", isMine: false, sender: user2, time: "오후 09:20")

var InTechs1 = [
    Message(message: "", type: "ENTER", isMine: false, sender: user1, time: "오후 09:20"),
    Message(message: "", type: "ENTER", isMine: false, sender: user3, time: "오후 09:20"),
    Message(message: "", type: "ENTER", isMine: false, sender: user2, time: "오후 09:20"),
    Message(message: "InTechs 최종 보고서.hwp", type: "FILE", isMine: true, sender: user1, time: "오후 09:20"),
    Message(message: "이걸로 보고서 최종 제출했습니다!", type: "TALK", isMine: true, sender: user1, time: "오후 09:20", isThread: true, threadMessages: [thread1]),
    Message(message: "인텍스 수고하셨습니당!!!!", type: "TALK", isMine: false, sender: user3, time: "오후 09:20"),
    Message(message: "인텍스 짱", type: "TALK", isMine: false, sender: user2, time: "오후 09:29")
]

var InTechs2 = [
    Message(message: "", type: "ENTER", isMine: false, sender: user1, time: "오후 09:20"),
    Message(message: "인텍스 iOS 방입니당ㅎ", type: "TALK", isMine: true, sender: user1, time: "오후 08:20")
]

var InTechs3 = [
    Message(message: "", type: "ENTER", isMine: false, sender: user1, time: "오후 09:20"),
    Message(message: "인텍스 백엔드 방입니당ㅎ", type: "TALK", isMine: true, sender: user1, time: "오후 08:21")
]

var DM1 = [
    Message(message: "종은아 발표 잘 해❤️", type: "TALK", isMine: true, sender: user1, time: "오전 09:21")
]

struct Channel: Identifiable, Equatable {
    var id = UUID().uuidString
    var lastMsg: String
    var lastMsgTime: String
    var pendingMsgs: String
    var name: String
    var imageUrl: String
    var allMsgs: [Message]
    var isNotification: Bool = false
    var notices: [Message] = []
}

var allHomes: [Channel] = [
    Channel(lastMsg: "인텍스 짱", lastMsgTime: "오후 09:29", pendingMsgs: "0", name: "인텍스", imageUrl: "placeholder", allMsgs: InTechs1, isNotification: true),
    Channel(lastMsg: "인텍스 iOS 방입니당ㅎ", lastMsgTime: "오후 08:20", pendingMsgs: "0", name: "인텍스 iOS", imageUrl: "placeholder", allMsgs: InTechs2,  isNotification: true),
    Channel(lastMsg: "인텍스 백엔드 방입니당ㅎ", lastMsgTime: "오후 08:21", pendingMsgs: "1", name: "인텍스 백엔드", imageUrl: "placeholder", allMsgs: InTechs3),
    Channel(lastMsg: "종은아 발표 잘 해❤️", lastMsgTime: "오전 09:21", pendingMsgs: "0", name: "이종은", imageUrl: "https://avatars.githubusercontent.com/u/66874658?v=4", allMsgs: DM1)
]

var allChannels: [Channel] = [
    Channel(lastMsg: "인텍스 짱", lastMsgTime: "오후 09:29", pendingMsgs: "0", name: "인텍스", imageUrl: "placeholder", allMsgs: InTechs1),
    Channel(lastMsg: "인텍스 iOS 방입니당ㅎ", lastMsgTime: "오후 08:20", pendingMsgs: "0", name: "인텍스 iOS", imageUrl: "placeholder", allMsgs: InTechs2),
    Channel(lastMsg: "인텍스 백엔드 방입니당ㅎ", lastMsgTime: "오후 08:21", pendingMsgs: "1", name: "인텍스 백엔드", imageUrl: "placeholder", allMsgs: InTechs3),
]

var allDMs: [Channel] = [
    Channel(lastMsg: "종은아 발표 잘 해❤️", lastMsgTime: "오전 09:21", pendingMsgs: "0", name: "이종은", imageUrl: "https://avatars.githubusercontent.com/u/66874658?v=4", allMsgs: DM1)
]
