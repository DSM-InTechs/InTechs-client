//
//  ProjectInfo.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/10/21.
//

import Foundation

public struct ProjectInfo: Codable, Hashable, Equatable {
    public var name: String
    public var image: ProjectInfoImage
}

public struct ProjectInfoImage: Codable, Hashable, Equatable {
    public var imageUrl: String
    public var oriName: String
}
