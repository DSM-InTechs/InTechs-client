//
//  Home.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/22.
//

import SwiftUI

struct Home: View {
    @ObservedObject private var homeVM = HomeViewModel()
    @Environment(\.scenePhase) var scenePhase
    
    init() {
        UITabBar.appearance().barTintColor = UIColor.secondarySystemBackground
    }
    
    var body: some View {
        if homeVM.isLogin {
            TabView {
                ChatListView()
                    .tabItem {
                        Image(system: .chat)
                        Text("채팅")
                    }

                IssuelistView()
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
                if newPhase == .inactive {
                    // Active API
                } else if newPhase == .background {
                    // InActive API
                }
            }
            
            .onAppear {
                TokenManager.email = "asdfasdf"
                print(TokenManager.email)
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
