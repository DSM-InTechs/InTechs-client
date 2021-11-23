//
//  Message.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/22.
//

import Foundation

struct Message: Identifiable, Equatable, Hashable {
    var id = UUID().uuidString
    var message: String
    var isMine: Bool
    var sender: User
    var time: String
    var isThread: Bool
    var threadMessages: [Message]?
    
    init(message: String, isMine: Bool, sender: User, time: String, isThread: Bool = false, threadMessages: [Message]? = nil) {
        self.message = message
        self.isMine = isMine
        self.sender = sender
        self.time = time
        self.isThread = isThread
        self.threadMessages = threadMessages
    }
}

var InTechs1 = [
    Message(message: "인텍스 수고하셨습니다!!", isMine: false, sender: User(name: "임서영", email: "dlatjdud@gmail.com", imageURL: "https://avatars.githubusercontent.com/u/66578746?v=4", isActive: false), time: "오후 09:20"),
    Message(message: "인텍스 짱", isMine: false, sender: User(name: "이종은", email: "jongeun@gmail.com", imageURL: "https://avatars.githubusercontent.com/u/66874658?v=4", isActive: true), time: "오후 09:29")
]

var InTechs2 = [
    Message(message: "인텍스 iOS 방입니당ㅎ", isMine: true, sender: User(name: "정고은", email: "gogo8272@gmail.com", imageURL: "https://avatars.githubusercontent.com/u/47523862?v=4", isActive: false), time: "오후 08:20")
]

var InTechs3 = [
    Message(message: "인텍스 백엔드 방입니당ㅎ", isMine: true, sender: User(name: "정고은", email: "gogo8272@gmail.com", imageURL: "https://avatars.githubusercontent.com/u/47523862?v=4", isActive: false), time: "오후 08:21")
]

var DM1 = [
    Message(message: "종은아 발표 잘 해❤️", isMine: true, sender: User(name: "정고은", email: "gogo8272@gmail.com", imageURL: "https://avatars.githubusercontent.com/u/47523862?v=4", isActive: false), time: "오전 09:21")
]

struct Channel: Identifiable, Equatable {
    var id = UUID().uuidString
    var lastMsg: String
    var lastMsgTime: String
    var pendingMsgs: String
    var name: String
    var imageUrl: String
    var allMsgs: [Message]
}

var allHomes: [Channel] = [
    Channel(lastMsg: "인텍스 짱", lastMsgTime: "오후 09:29", pendingMsgs: "0", name: "인텍스", imageUrl: "placeholder", allMsgs: InTechs1),
    Channel(lastMsg: "인텍스 iOS 방입니당ㅎ", lastMsgTime: "오후 08:20", pendingMsgs: "0", name: "인텍스 iOS", imageUrl: "placeholder", allMsgs: InTechs2),
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
