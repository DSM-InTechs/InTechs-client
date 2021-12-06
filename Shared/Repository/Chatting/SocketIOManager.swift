//
//  SocketIOManager.swift
//  InTechs
//
//  Created by GoEun Jeong on 2021/12/05.
//

import Foundation
import SocketIO

public class SocketIOManager {
    public static let shared = SocketIOManager()
    
    private var manager = SocketManager(socketURL: URL(string: "http://localhost:8010")!, config: [.log(true), .compress])
    public var socket: SocketIOClient!
    private var channelId: String = ""
    
    @UserDefault(key: "accessToken", defaultValue: "")
    private var accessToken: String
    
    private init() {
        self.manager.config = SocketIOClientConfiguration(arrayLiteral: .connectParams(["token": accessToken]))
        self.socket = self.manager.defaultSocket
    }
    
    public func connectChannel(channelId: String) {
        self.channelId = channelId
        self.connect()
    }
    
    deinit {
        socket.disconnect()
    }
    
    private func connect() {
        socket.connect()
        
        socket.on(clientEvent: .connect) { _, _ in
            self.socket.emit("joinChannel", self.channelId)
        }
    }
    
    public func on(_ api: InTechsSocket, callback: @escaping (([Any], SocketAckEmitter) -> Void)) {
        socket.on(api.event(), callback: callback)
    }
    
    public func on(_ socketEvent: SocketClientEvent, callback: @escaping (([Any], SocketAckEmitter) -> Void)) {
        socket.on(clientEvent: socketEvent, callback: callback)
    }
    
    public func emit(_ api: InTechsSocket) {
        socket.emit(api.event(), api.items()!)
    }
}
