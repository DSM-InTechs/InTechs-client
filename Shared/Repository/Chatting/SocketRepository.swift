//
//  SocketRepository.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/12/01.
//

import Foundation
import SocketIO

final public class SocketRepository: NSObject {
    static let shared = SocketRepository()
    var manager = SocketManager(socketURL: URL(string: "http://localhost:9000")!, config: [.log(true), .compress])
    var socket: SocketIOClient!
    
    override init() {
        super.init()
        socket = self.manager.socket(forNamespace: "/test")
        socket.on("test") { dataArray, ack in
            print(dataArray)
        }
    }
    
    func connect() {
        socket.connect()
    }
    
    func disconnect() {
        socket.disconnect()
    }
    
    func sendMessage(message: String, nickname: String) {
        socket.emit("event", ["message" : "This is a test message"])
        socket.emit("event1", [["name" : "ns"], ["email" : "@naver.com"]])
        socket.emit("event2", ["name" : "ns", "email" : "@naver.com"])
        socket.emit("msg", ["nick": nickname, "msg" : message]) }
}
