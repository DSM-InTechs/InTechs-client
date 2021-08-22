//
//  ProjectTab.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/08/22.
//

import SwiftUI

enum ProjectTab: String {
    case DashBoard
    case Issues
    case IssueBoards
    case Settings
}

extension ProjectTab {
    func getImage() -> String {
        switch self {
        case .DashBoard:
            return "square.grid.2x2.fill"
        case .Issues:
            return "flame"
        case .IssueBoards:
            return "list.bullet.rectangle"
        case .Settings:
            return "gearshape.fill"
        }
    }
}
