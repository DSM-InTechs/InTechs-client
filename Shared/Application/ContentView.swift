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
                        case .channelInfo:
                            ChannelInfoView()
                                .modifier(ToastModiier())
                                .frame(width: geo.size.width / 1.3, height: geo.size.height / 1.3)
                        case .channelSearch:
                            ChannelSearchView()
                                .modifier(ToastModiier())
                                .frame(width: geo.size.width / 1.3, height: geo.size.height / 1.3)
                        case .channelRename:
                            ChannelRenameView()
                                .modifier(ToastModiier())
                                .frame(width: geo.size.width / 1.3, height: geo.size.height / 3)
                                .environmentObject(homeViewModel)
                        case .channelDelete:
                            ChannelDeleteView()
                                .modifier(ToastModiier())
                                .frame(width: geo.size.width / 1.5, height: geo.size.height / 3)
                                .environmentObject(homeViewModel)
                        case .channelCreate:
                            NewChannelView()
                                .modifier(ToastModiier())
                                .frame(width: geo.size.width / 1.3, height: geo.size.height / 1.2)
                                .environmentObject(homeViewModel)
                        case .messageDelete:
                            MessagelDeleteView()
                                .modifier(ToastModiier())
                                .frame(width: geo.size.width / 1.5, height: geo.size.height / 3)
                                .environmentObject(homeViewModel)
                        case .issueDelete:
                            IssueDeleteView()
                                .modifier(ToastModiier())
                                .frame(width: geo.size.width / 1.5, height: geo.size.height / 3)
                                .environmentObject(homeViewModel)
                        case .issueCreate:
                            NewIssueView()
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
