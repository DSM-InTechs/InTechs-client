//
//  Mypage.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/10/07.
//

import Foundation

public struct User: Codable, Hashable, Equatable {
    public var name: String
    public var email: String
    public var imageURL: String
    public var isActive: Bool
    
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case imageURL = "imageUri"
        case isActive
    }
}
