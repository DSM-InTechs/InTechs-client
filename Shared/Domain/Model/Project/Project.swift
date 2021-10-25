//
//  Project.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/10/07.
//

import Foundation

public struct Project: Codable, Hashable, Equatable {
    public var id: Int
    public var name: String
    public var image: String
    public var createdAt: String
}
