//
//  HomeTab.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/22.
//

import Foundation

enum HomeTab: String {
    case chats = "채팅"
    case projects = "프로젝트"
    case calendar = "캘린더"
    case teams = "팀"
    case mypage = "마이페이지"
}

extension HomeTab {
    func getImage() -> String {
        switch self {
        case .chats:
            return "message.fill"
        case .projects:
            return "square.grid.2x2"
        case .calendar:
            return "calendar"
        case .teams:
            return "person.2"
        case .mypage:
            return "person.circle"
        }
    }
}
