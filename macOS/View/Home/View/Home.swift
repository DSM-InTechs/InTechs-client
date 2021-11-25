//
//  Home.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/08/22.
//

import SwiftUI
import Kingfisher

struct Home: View {
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var homeVM: HomeViewModel
    @State private var quickActionPop: Bool = false
    @State private var questionPop: Bool = false
    @State private var mypagePop: Bool = false
    
    var body: some View {
        if homeVM.isLogin {
            ZStack(alignment: .leading) {
                ZStack {
                    switch homeVM.selectedTab {
                    case .chats: NavigationView { ChatListView().background(Color(NSColor.textBackgroundColor)).ignoresSafeArea() }
                    case .projects: ProjectListView()
                    case .calendar: CalendarView()
                    case .teams: MemberView()
                    case .mypage: MypageView()
                    }
                }
                .offset(x: 70)
                
                VStack {
                    HomeTabButton(tab: HomeTab.chats, number: "1", selectedTab: $homeVM.selectedTab)
                        .keyboardShortcut("1", modifiers: .command)
                    
                    HomeTabButton(tab: HomeTab.projects,
                                  number: "2",
                                  selectedTab: $homeVM.selectedTab)
                        .keyboardShortcut("2", modifiers: [.command])
                    
                    HomeTabButton(tab: HomeTab.calendar,
                                  number: "3",
                                  selectedTab: $homeVM.selectedTab)
                        .keyboardShortcut("3", modifiers: [.command])
                    
                    HomeTabButton(tab: HomeTab.teams,
                                  number: "4",
                                  selectedTab: $homeVM.selectedTab)
                        .keyboardShortcut("4", modifiers: [.command])
                    
                    Spacer()
                    
                    LazyVStack {
                        ForEach(homeVM.myProjects, id: \.self) { project in
                            KFImage(URL(string: project.image))
                                .resizable()
                                .frame(width: 28, height: 28)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(
                                    ZStack {
                                        if project.id == homeVM.currentProject {
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.white, lineWidth: 1.5)
                                                .frame(width: 37, height: 37)
                                        }
                                    }
                                )
                                .padding(.bottom, 5)
                                .onAppear {
                                    print(project.id == homeVM.currentProject )
                                    print(homeVM.currentProject)
                                }
                                .onTapGesture {
                                    homeVM.currentProject = project.id
                                }
                        }
                    }
                    
                    Image(system: .plusSquare)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.gray)
                        .frame(height: 40)
                        .onTapGesture {
                            self.quickActionPop.toggle()
                        }.popover(isPresented: $quickActionPop) {
                            QuickActionPopView(isPop: $quickActionPop).frame(width: 200)
                        }
                    
                    Image(system: .question)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.gray)
                        .frame(height: 40)
                        .onTapGesture {
                            self.questionPop.toggle()
                        }.popover(isPresented: $questionPop) {
                            HelpPopView()             .frame(width: 300)
                        }
                    
                    HomeTabButton(tab: HomeTab.mypage,
                                  imageUrl: homeVM.profile.image, mypageTapped: {
                        self.mypagePop.toggle()
                    }, selectedTab: $homeVM.selectedTab).popover(isPresented: $mypagePop) {
                        MypagePopView(imageURL: homeVM.profile.image, name: homeVM.profile.name) .frame(width: 200)
                    }
                }
                .frame(width: 70)
                .padding(.vertical)
                .padding(.top, 35)
                .background(BlurView())
                
                if homeVM.myProjects.isEmpty {
                    ZStack {
                        Color.white
                        
                        VStack {
                            Text("프로젝트에 가입되어 있지 않습니다.")
                                .foregroundColor(.gray)
                                .fontWeight(.bold)
                                .font(.title2)
                                .padding()
                            
                            HStack(alignment: .bottom, spacing: 20) {
                                Text("프로젝트 생성")
                                    .padding(.all, 10)
                                    .foregroundColor(.black)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.black, lineWidth: 1)
                                    ).onTapGesture {
                                        withAnimation {
                                            self.homeVM.toast = .projectCreate
                                        }
                                    }
                                
                                Text("프로젝트 가입")
                                    .padding(.all, 10)
                                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.black)).onTapGesture {
                                        withAnimation {
                                            self.homeVM.toast = .projectJoin
                                        }
                                    }
                            }
                        }
                    }.offset(x: 70)
                        .padding(.trailing, 70)
                }
                
                if homeVM.selectedTab == .mypage {
                    MypageView()
                        .offset(x: 70)
                        .padding(.trailing, 70)
                }
            }
            .ignoresSafeArea(.all, edges: .all)
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    homeVM.apply(.changeActive(isActive: true))
                } else if newPhase == .background {
                    homeVM.apply(.changeActive(isActive: false))
                }
            }
            .onAppear {
                self.homeVM.apply(.onAppear)
            }
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
            
            QuickActionPopView(isPop: .constant(false))
                .frame(width: 200)
            
            HelpPopView()
                .frame(width: 300)
            
            MypagePopView(imageURL: "asdf", name: "asdf")
                .frame(width: 300)
        }
    }
}

struct QuickActionPopView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    @Binding var isPop: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("#")
                    .frame(width: 15, height: 15)
                Text("채널")
                    .fixedSize(horizontal: true, vertical: false)
                Spacer()
            }.onTapGesture {
                withAnimation {
                    self.isPop = false
                    self.homeVM.toast = .channelCreate
                }
            }
            
            HStack {
                SystemImage(system: .issue)
                    .frame(width: 15, height: 15)
                Text("이슈")
            }.onTapGesture {
                withAnimation {
                    self.isPop = false
                    self.homeVM.toast = .issueCreate(execute: {
                        fatalError()
                    })
                }
            }
            
            HStack {
                SystemImage(system: .project)
                    .frame(width: 15, height: 15)
                Text("프로젝트")
            }.onTapGesture {
                withAnimation {
                    self.isPop = false
                    self.homeVM.toast = .projectCreate
                }
            }
        }.padding()
    }
}

struct HelpPopView: View {
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

struct MypagePopView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    
    let imageURL: String
    let name: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                KFImage(URL(string: imageURL))
                    .resizable()
                    .frame(width: 35, height: 35)
                Text(name)
                Spacer()
                Image(system: .edit)
            }.onTapGesture {
                withAnimation {
                    self.homeVM.selectedTab = .mypage
                }
            }
            
            Divider()
            
            HStack {
                Image(system: .logout)
                Text("로그아웃").onTapGesture {
                    self.homeVM.logout()
                }
            }
        }.padding()
    }
}
