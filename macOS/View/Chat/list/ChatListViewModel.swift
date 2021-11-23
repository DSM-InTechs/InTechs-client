//
//  ChatViewModel.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/22.
//

import SwiftUI

class ChatListViewModel: ObservableObject {
    @Published var selectedTab: ChatTab = .home
    
    @Published var selectedHome: Int? = 0
    @Published var homes: [Channel] = allHomes
    
    @Published var selectedDM: Int? = 0
    @Published var DMs: [Channel] = allDMs
    
    @Published var selectedChannel: Int? = 0
    @Published var channels: [Channel] = allChannels
    
    func sendMessage(channel: Channel, message: String) {
        let index = channels.firstIndex { currentChannel -> Bool in
            return currentChannel.id == channel.id
        } ?? -1
        if index != -1 {
            channels[index].allMsgs.append(Message(message: message, type: "TALK", isMine: true, sender: User(name: "정고은", email: "gogo8272@gmail.com", imageURL: "https://avatars.githubusercontent.com/u/47523862?v=4", isActive: false), time: "오후 09:37"))
        }
    }
    
    func exitChannel() {
        switch self.selectedTab {
        case .home:
            homes.remove(at: self.selectedHome!)
            self.selectedHome = 0
        case .channels:
            channels.remove(at: self.selectedChannel!)
            self.selectedChannel = 0
        case .DMs:
            DMs.remove(at: self.selectedDM!)
            self.selectedDM = 0
        }
    }
}
