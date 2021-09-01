//
//  HomeViewModel.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/22.
//

import SwiftUI

enum Toast {
    case channelSearch
    case channelInfo
    case channelRename
    case channelDelete
}

class HomeViewModel: ObservableObject {
    @Published var isLogin: Bool = false
    
    @Published var selectedTab: HomeTab = HomeTab.chats
    @Published var toast: Toast?
    
    @Published var selectedRecentMsg: String? = recentMsgs.first?.id
    @Published var msgs: [RecentMessage] = recentMsgs
    
    @Published var message = ""
    
    func sendMessage(user: RecentMessage) {
        let index = msgs.firstIndex { currentUser -> Bool in
            return currentUser.id == user.id
        } ?? -1
        if index != -1 {
            msgs[index].allMsgs.append(Message(message: message, myMessage: true))
            message = ""
        }
    }
}
