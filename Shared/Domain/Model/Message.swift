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
    Message(message: "메세지1", myMessage: false),
    Message(message: "메세지 예시", myMessage: false),
    Message(message: "메세지메세지메세지", myMessage: true),
    Message(message: ".", myMessage: false),
    Message(message: "ㅡㅡ", myMessage: true),
    Message(message: "..", myMessage: true),
    Message(message: "메세지", myMessage: false)
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
    RecentMessage(lastMsg: "마지막 메세지", lastMsgTime: "15:00", pendingMsgs: "0", userName: "유저", userImage: "placeholder", allMsgs: eachmsg.shuffled()),
    RecentMessage(lastMsg: "마지막 메세지", lastMsgTime: "15:00", pendingMsgs: "0", userName: "유저", userImage: "placeholder", allMsgs: eachmsg.shuffled()),
    RecentMessage(lastMsg: "마지막 메세지", lastMsgTime: "15:00", pendingMsgs: "2", userName: "유저", userImage: "placeholder", allMsgs: eachmsg.shuffled()),
    RecentMessage(lastMsg: "마지막 메세지", lastMsgTime: "15:00", pendingMsgs: "5", userName: "유저", userImage: "placeholder", allMsgs: eachmsg.shuffled()),
    RecentMessage(lastMsg: "마지막 메세지", lastMsgTime: "15:00", pendingMsgs: "11", userName: "유저", userImage: "placeholder", allMsgs: eachmsg.shuffled()),
    RecentMessage(lastMsg: "마지막 메세지", lastMsgTime: "15:00", pendingMsgs: "9", userName: "유저", userImage: "placeholder", allMsgs: eachmsg.shuffled())
]
