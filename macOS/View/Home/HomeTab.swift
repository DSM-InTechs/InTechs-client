//
//  HomeTab.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/22.
//

import Foundation

enum HomeTab: String {
    case Chats
    case Projects
    case Calendar
    case Teams
    case Help
    case Mypage
}

extension HomeTab {
    func getImage() -> String {
        switch self {
        case .Chats:
            return "message.fill"
        case .Projects:
            return "square.grid.2x2"
        case .Calendar:
            return "calendar"
        case .Teams:
            return "person.2"
        case .Help:
            return "questionmark"
        case .Mypage:
            return "person.circle"
        }
    }
}
