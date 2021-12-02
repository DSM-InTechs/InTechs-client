//
//  SendMessage.swift
//  InTechs
//
//  Created by GoEun Jeong on 2021/12/02.
//

import Foundation
import SocketIO

public struct MessageRequest: SocketData {
    public var channelId: String
    public var message: String
    
    public func socketRepresentation() -> SocketData {
        return ["channelId": channelId, "message": message]
    }
}
