//
//  HomeTab.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/22.
//

import Foundation

enum HomeTab: String {
    case Chats = "채팅"
    case Projects = "프로젝트"
    case Calendar = "캘린더"
    case Teams = "팀"
    case Mypage = "마이페이지"
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
        case .Mypage:
            return "person.circle"
        }
    }
}
