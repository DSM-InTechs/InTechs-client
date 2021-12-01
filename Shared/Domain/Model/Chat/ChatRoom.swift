//
//  ChatRoom.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/12/01.
//

import Foundation

public struct ChatRoom: Codable, Hashable, Equatable {
    public var id: String
    public var name: String
    public var image: String
    public var message: String
    public var time: String
}
