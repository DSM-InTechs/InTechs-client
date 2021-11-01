//
//  Home.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/22.
//

import SwiftUI

struct Home: View {
    @StateObject private var homeVM = HomeViewModel()
    @Environment(\.scenePhase) var scenePhase
    
    init() {
        UITabBar.appearance().barTintColor = UIColor.secondarySystemBackground
    }
    
    var body: some View {
        if homeVM.isLogin {
            TabView {
                ChatListView()
                    .environmentObject(homeVM)
                    .tabItem {
                        Image(system: .chat)
                        Text("채팅")
                    }

                IssuelistView()
                    .environmentObject(homeVM)
                    .tabItem {
                        Image(system: .issue)
                        Text("이슈")
                    }
                
                CalendarView()
                    .environmentObject(homeVM)
                    .tabItem {
                        Image(system: .calendar)
                        Text("마이페이지")
                    }
            }.accentColor(Color(Asset.black.color))
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    homeVM.apply(.changeActive(isActive: true))
                } else if newPhase == .background {
                    homeVM.apply(.changeActive(isActive: false))
                }
            }
        } else {
            InTechsView()
                .environmentObject(homeVM)
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
