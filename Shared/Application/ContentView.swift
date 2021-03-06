//
//  ContentView.swift
//  Shared
//
//  Created by GoEun Jeong on 2021/08/21.
//

import SwiftUI

struct ContentView: View {
    #if os(iOS)
    var body: some View {
        Home()
    }
    
    #endif
    
    #if os(OSX)
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Home()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .environmentObject(homeViewModel)
                
                if homeViewModel.toast != nil {
                    ZStack {
                        Color.black.opacity(0.5)
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation {
                                    homeViewModel.toast = nil
                                }
                            }
                        
                        switch homeViewModel.toast {
                        case .userDelete(let execute):
                            UserDeleteView(execute: execute)
                                .modifier(ToastModiier())
                                .frame(width: geo.size.width / 1.5, height: geo.size.height / 3)
                                .environmentObject(homeViewModel)
                        case .channelInfo(let channelId):
                            ChannelInfoView(id: channelId)
                                .modifier(ToastModiier())
                                .frame(width: geo.size.width / 1.3, height: geo.size.height / 1.3)
                        case .channelSearch(let channelId):
                            ChannelSearchView(id: channelId)
                                .modifier(ToastModiier())
                                .frame(width: geo.size.width / 1.3, height: geo.size.height / 1.3)
                        case let .channelRename(channel, execute):
                            ChannelRenameView(channel: channel, execute: execute)
                                .modifier(ToastModiier())
                                .frame(width: geo.size.width / 1.3, height: geo.size.height / 3)
                                .environmentObject(homeViewModel)
                        case let .channelExit(channel, execute):
                            ChannelExitView(channel: channel, execute: execute)
                                .modifier(ToastModiier())
                                .frame(width: geo.size.width / 1.5, height: geo.size.height / 3)
                                .environmentObject(homeViewModel)
                        case let .channelDelete(channel, execute):
                            ChannelDeleteView(channel: channel, execute: execute)
                                .modifier(ToastModiier())
                                .frame(width: geo.size.width / 1.5, height: geo.size.height / 3)
                                .environmentObject(homeViewModel)
                        case .channelCreate(let execute, let isDM):
                            NewChannelView(isDM: isDM, execute: execute)
                                .modifier(ToastModiier())
                                .frame(width: geo.size.width / 1.3, height: geo.size.height / 1.2)
                                .environmentObject(homeViewModel)
                        case .messageDelete(let execute):
                            MessagelDeleteView(execute: execute)
                                .modifier(ToastModiier())
                                .frame(width: geo.size.width / 1.5, height: geo.size.height / 3)
                                .environmentObject(homeViewModel)
                        case .issueDelete(let execute):
                            IssueDeleteView(execute: execute)
                                .modifier(ToastModiier())
                                .frame(width: geo.size.width / 1.5, height: geo.size.height / 3)
                                .environmentObject(homeViewModel)
                        case .issueCreate(let execute):
                            NewIssueView(execute: execute)
                                .modifier(ToastModiier())
                                .frame(width: geo.size.width / 1.3, height: geo.size.height / 1.2)
                                .environmentObject(homeViewModel)
                        case .projectCreateOrJoin:
                            ProjectCreateJoinView()
                                .modifier(ToastModiier())
                                .frame(width: geo.size.width / 1.3, height: geo.size.height / 1.2)
                                .environmentObject(homeViewModel)
                        case .projectCreate:
                            NewProjectView()
                                .modifier(ToastModiier())
                                .frame(width: geo.size.width / 1.3, height: geo.size.height / 1.2)
                                .environmentObject(homeViewModel)
                        case .projectJoin:
                            ProjectJoinView()
                                .modifier(ToastModiier())
                                .frame(width: geo.size.width / 1.3, height: geo.size.height / 1.2)
                                .environmentObject(homeViewModel)
                        case .projectExit(let execute):
                            ProjectExitView(execute: execute)
                                .modifier(ToastModiier())
                                .frame(width: geo.size.width / 1.5, height: geo.size.height / 3)
                                .environmentObject(homeViewModel)
                        case .projectDelete(let execute):
                            ProjectDeleteView(execute: execute)
                                .modifier(ToastModiier())
                                .frame(width: geo.size.width / 1.5, height: geo.size.height / 3)
                                .environmentObject(homeViewModel)
                        case .none:
                            Text("")
                                .opacity(0)
                        }
                    }
                }
            }
        }
    }
    #endif
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
