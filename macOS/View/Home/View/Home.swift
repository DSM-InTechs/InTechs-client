//
//  Home.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/08/22.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject var homeData: HomeViewModel
    @State private var quickActionPop: Bool = false
    @State private var questionPop: Bool = false
    
    @State private var isLogin: Bool = true
    
    var body: some View {
        if isLogin {
            ZStack(alignment: .leading) {
                ZStack {
                    switch homeData.selectedTab {
                    case .Chats: NavigationView { ChatListView().background(Color(NSColor.textBackgroundColor)).ignoresSafeArea() }
                    case .Projects: ProjectListView()
                    case .Calendar: CalendarView()
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
                    
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 30, height: 30)
                        .padding(.bottom, 5)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 30, height: 30)
                        .padding(.bottom, 5)
                    
                    Image(system: .plusSquare)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.gray)
                        .frame(height: 40)
                        .onTapGesture {
                            self.quickActionPop.toggle()
                        }.popover(isPresented: $quickActionPop) {
                            quickActionPopView().frame(width: 200)
                        }
                    
                    Image(system: .question)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.gray)
                        .frame(height: 40)
                        .onTapGesture {
                            self.questionPop.toggle()
                        } .popover(isPresented: $questionPop) {
                            helpPopView()             .frame(width: 300)
                        }
                    
                    HomeTabButton(tab: HomeTab.Mypage,
                                  selectedTab: $homeData.selectedTab)
                }
                .frame(width: 70)
                .padding(.vertical)
                .padding(.top, 35)
                .background(BlurView())
            }
            .ignoresSafeArea(.all, edges: .all)
        } else {
            InTechsView()
                .ignoresSafeArea(.all, edges: .all)
        }
    }
}

struct Home_Previews: PreviewProvider {
    @ObservedObject static var homeViewModel = HomeViewModel()
    
    static var previews: some View {
        Group {
            Home()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .environmentObject(homeViewModel)
            
            quickActionPopView()
                .frame(width: 200)
            
            helpPopView()
                .frame(width: 300)
        }
    }
}

struct quickActionPopView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("#")
                    .frame(width: 15, height: 15)
                Text("채널")
                    .fixedSize(horizontal: true, vertical: false)
                Spacer()
            }
            HStack {
                SystemImage(system: .issue)
                    .frame(width: 15, height: 15)
                Text("이슈")
            }
            HStack {
                SystemImage(system: .calendar)
                    .frame(width: 15, height: 15)
                Text("일정")
            }
            HStack {
                SystemImage(system: .person)
                    .frame(width: 15, height: 15)
                Text("멤버")
            }
        }.padding()
    }
}

struct helpPopView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("피드백 보내기")
            Text("키보드 단축키 보기")
            Text("다운로드")
            HStack {
                Image(Asset.appstore)
                Image(Asset.macAppstore)
            }
        }.padding()
    }
}
