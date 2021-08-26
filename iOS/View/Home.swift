//
//  Home.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/22.
//

import SwiftUI

struct Home: View {
    init() {
        UITabBar.appearance().barTintColor = UIColor.secondarySystemBackground
    }
    
    var body: some View {
        TabView {
            ChatListView()
                .tabItem {
                    Image(system: .chat)
                    Text("채팅")
                }

            CalendarView()
                .tabItem {
                    Image(system: .calendar)
                    Text("일정")
                }
            
            MypageView()
                .tabItem {
                    Image(system: .person)
                    Text("마이페이지")
                }
        }.accentColor(Color(Asset.black.color))

    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
