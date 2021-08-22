//
//  Message.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/22.
//

import Foundation

struct Message: Identifiable, Equatable {
    var id = UUID().uuidString
    var message: String
    var myMessage: Bool
}

var eachmsg = [
    Message(message: "asdfasdfasdf", myMessage: false),
    Message(message: "asdf", myMessage: false),
    Message(message: "응", myMessage: true),
    Message(message: "qwerqefsfvsdgwerrfasd", myMessage: false),
    Message(message: "응", myMessage: true),
    Message(message: "asdfadsf", myMessage: true),
    Message(message: "응", myMessage: false)
]

struct RecentMessage: Identifiable {
    var id = UUID().uuidString
    var lastMsg: String
    var lastMsgTime: String
    var pendingMsgs: String
    var userName: String
    var userImage: String
    var allMsgs: [Message]
}

var recentMsgs: [RecentMessage] = [
    RecentMessage(lastMsg: "Apple Tech", lastMsgTime: "15:00", pendingMsgs: "9", userName: "나다", userImage: "placeholder", allMsgs: eachmsg.shuffled()),
    RecentMessage(lastMsg: "Apple Tech", lastMsgTime: "15:00", pendingMsgs: "9", userName: "나다", userImage: "placeholder", allMsgs: eachmsg.shuffled()),
    RecentMessage(lastMsg: "Apple Tech", lastMsgTime: "15:00", pendingMsgs: "9", userName: "나다", userImage: "placeholder", allMsgs: eachmsg.shuffled()),
    RecentMessage(lastMsg: "Apple Tech", lastMsgTime: "15:00", pendingMsgs: "9", userName: "나다", userImage: "placeholder", allMsgs: eachmsg.shuffled()),
    RecentMessage(lastMsg: "Apple Tech", lastMsgTime: "15:00", pendingMsgs: "9", userName: "나다", userImage: "placeholder", allMsgs: eachmsg.shuffled()),
    RecentMessage(lastMsg: "Apple Tech", lastMsgTime: "15:00", pendingMsgs: "9", userName: "나다", userImage: "placeholder", allMsgs: eachmsg.shuffled())
]
