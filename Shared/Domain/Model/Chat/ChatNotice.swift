//
//  ChatNotice.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/12/01.
//

import Foundation

public struct ChatNotice: Codable, Hashable, Equatable {
    public var name: String
    public var message: String
    public var time: String
}
