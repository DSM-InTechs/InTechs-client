//
//  InTechsSocket.swift
//  InTechs
//
//  Created by GoEun Jeong on 2021/12/05.
//

import Foundation

public enum InTechsSocket {
    
    // MARK: - emit
    case joinChannel
    case sendMessage(channelId: String, message: String)
    case sendThreadMessage(channelId: String, messageId: String, message: String)
    case updateMessage(channelId: String, messageId: String, newMessage: String)
    case deleteMessage(channelId: String, messageId: String)
    
    // MARK: - on
    case getMessage
    case getFileMessage
    case getThreadMessage
    case getUpdatedMessage
    case getDeletedMessage
    
    public func event() -> String {
        switch  self {
        case .joinChannel:
            return "joinChannel"
        case .sendMessage, .getMessage:
            return "send"
        case .sendThreadMessage, .getThreadMessage:
            return "thread"
        case .updateMessage, .getUpdatedMessage:
            return "update"
        case .deleteMessage, .getDeletedMessage:
            return "delete"
            
        case .getFileMessage:
            return "send-file"
        }
    }
    
    public func items() -> [String: Any]? {
        switch self {
        case let .sendMessage(channelId, message):
            return ["channelId": channelId, "message": message]
        case let .sendThreadMessage(channelId, messageId, message):
            return ["channelId": channelId, "chatId": messageId, "message": message]
        case let.updateMessage(channelId, messageId, newMessage):
            return ["channelId": channelId, "chatId": messageId, "message": newMessage]
        case let .deleteMessage(channelId, messageId):
            return ["channelId": channelId, "messageId": messageId]
        default:
            return nil
        }
    }
}
