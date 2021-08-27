//
//  Home.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/22.
//

import SwiftUI

struct Home: View {
    @State var isLogin: Bool = true
    
    init() {
        UITabBar.appearance().barTintColor = UIColor.secondarySystemBackground
    }
    
    var body: some View {
        if isLogin {
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
                    .tabItem {
                        Image(system: .calendar)
                        Text("마이페이지")
                    }
            }.accentColor(Color(Asset.black.color))
        } else {
            InTechsView()
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
