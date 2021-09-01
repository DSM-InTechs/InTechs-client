//
//  ProjectTab.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/08/22.
//

import SwiftUI

enum ProjectTab: String {
    case dashBoard = "대쉬보드"
    case issues = "이슈"
    case issueBoards = "이슈보드"
    case settings = "설정"
}

extension ProjectTab {
    func getImage() -> String {
        switch self {
        case .dashBoard:
            return "square.grid.2x2.fill"
        case .issues:
            return "flame"
        case .issueBoards:
            return "list.bullet.rectangle"
        case .settings:
            return "gearshape.fill"
        }
    }
}
