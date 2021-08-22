//
//  Home.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/08/22.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject var homeData: HomeViewModel
    
    var body: some View {
        ZStack(alignment: .leading) {
            ZStack {
                switch homeData.selectedTab {
                case .Chats: NavigationView { ChatListView() }
                case .Projects: ProjectListView()
                case .Calendar: Text("Calendar")
                case .Teams: MemberView()
                default: Text("")
                }
            }
            .offset(x: 70)
            
            VStack {
                HomeTabButton(tab: HomeTab.Chats, number: "1", selectedTab: $homeData.selectedTab)
                    .keyboardShortcut("1", modifiers: .command)
                
                HomeTabButton(tab: HomeTab.Projects,
                          number: "2",
                          selectedTab: $homeData.selectedTab)
                    .keyboardShortcut("2", modifiers: [.command])
                
                HomeTabButton(tab: HomeTab.Calendar,
                    number: "3",
                    selectedTab: $homeData.selectedTab)
                    .keyboardShortcut("3", modifiers: [.command])
                
                HomeTabButton(tab: HomeTab.Teams,
                          number: "4",
                          selectedTab: $homeData.selectedTab)
                    .keyboardShortcut("4", modifiers: [.command])
                
                Spacer()
                
                HomeTabButton(tab: HomeTab.Help,
                          number: "?",
                          selectedTab: $homeData.selectedTab)
                
                HomeTabButton(tab: HomeTab.Mypage,
                          selectedTab: $homeData.selectedTab)
            }
            .frame(width: 70)
            .padding(.vertical)
            .padding(.top, 35)
            .background(BlurView())
        }
        .ignoresSafeArea(.all, edges: .all)
    }
}

struct Home_Previews: PreviewProvider {
    @ObservedObject static var homeViewModel = HomeViewModel()
    
    static var previews: some View {
        Home()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .environmentObject(homeViewModel)
    }
}
