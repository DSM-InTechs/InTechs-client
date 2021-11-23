//
//  ChatViewModel.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/22.
//

import SwiftUI

class ChatListViewModel: ObservableObject {
    @Published var selectedTab: ChatTab = .home
    
    @Published var selectedHome: String? = allHomes.first?.id
    @Published var homes: [Channel] = allHomes
    
    @Published var selectedDM: String? = allDMs.first?.id
    @Published var DMs: [Channel] = allDMs
    
    @Published var selectedChannel: String? = allChannels.first?.id
    @Published var channels: [Channel] = allChannels
    
    func sendMessage(channel: Channel, message: String) {
        let index = channels.firstIndex { currentChannel -> Bool in
            return currentChannel.id == channel.id
        } ?? -1
        if index != -1 {
            channels[index].allMsgs.append(Message(message: message, isMine: true, sender: User(name: "정고은", email: "gogo8272@gmail.com", imageURL: "https://avatars.githubusercontent.com/u/47523862?v=4", isActive: false), time: "오후 09:37"))
        }
    }
    
    func exitChannel() {
        switch self.selectedTab {
        case .home:
            let currentHome = self.homes.filter { $0.id == self.selectedHome }.first!
            
            for (index, home) in self.homes.enumerated() {
                if currentHome == home {
                    homes.remove(at: index)
                    selectedHome = homes.first?.id
                }
            }
        case .channels:
            let currentChannel = self.channels.filter { $0.id == self.selectedChannel }.first!
            
            for (index, channel) in self.channels.enumerated() {
                if currentChannel == channel {
                    channels.remove(at: index)
                    selectedChannel = channels.first?.id
                }
            }
        case .DMs:
            let currentDM = self.DMs.filter { $0.id == self.selectedDM }.first!
            
            for (index, DM) in self.DMs.enumerated() {
                if currentDM == DM {
                    DMs.remove(at: index)
                    selectedDM = DMs.first?.id
                }
            }
        }
    }
}
