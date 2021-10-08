//
//  LoginResponse.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/10/04.
//

import Foundation

public struct AuthReponse: Codable, Hashable, Equatable {
    public var accessToken: String
    public var refreshToken: String
    public var tokenType: String?
}
