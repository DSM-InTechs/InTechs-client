//
//  ChatListView.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/22.
//

import SwiftUI
import Kingfisher

struct ChatListView: View {
    @State private var index = 1
    @State private var offset: CGFloat = 0
    @Namespace private var animation
    @State private var showNewChat = false
    
    @State var uiTabarController: UITabBarController?
    @ObservedObject var viewModel = ChatlistViewModel()
    
    init() {
        UINavigationBar.appearance().barTintColor = Asset.white.color
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: -1) {
                        ChatBar(index: self.$index, offset: self.$offset, animation: animation)
                            .frame(width: UIFrame.width / 1.85, height: UIFrame.width / 7.5)
                        
                        Divider()
                    }
                    
                    Spacer()
                }
                
                GeometryReader { geo in
                    HStack(spacing: 0) {
                        // First View
                        ScrollView {
                            LazyVStack {
                                ForEach(0..<viewModel.homes.count, id: \.self) { index in
                                    NavigationLink(destination: ChatDetailView(channel: $viewModel.homes[index], title: viewModel.homes[index].name)) {
                                        ChannelRow(channel: viewModel.homes[index])
                                            .padding(.all, 10)
                                    }
                                    
                                }
                            }
                        }
                        .frame(width: geo.frame(in: .global).width)
                        
                        // Second View
                        VStack {
                            LazyVStack {
                                ForEach(viewModel.channels, id: \.id) { channel in
                                    ChannelRow(channel: channel)
                                        .padding(.all, 10)
                                }
                            }
                            Spacer(minLength: 0)
                        }
                        .frame(width: geo.frame(in: .global).width)
                        
                        // Third View
                        VStack {
                            LazyVStack {
                                ForEach(viewModel.DMs, id: \.id) { channel in
                                    ChannelRow(channel: channel)
                                        .padding(.all, 10)
                                }
                            }
                            Spacer(minLength: 0)
                        }
                        .frame(width: geo.frame(in: .global).width)
                    }.offset(x: -self.offset)
                    .highPriorityGesture(DragGesture()
                                            .onEnded({ value in
                                                if value.translation.width > 50 {
                                                    changeView(left: false)
                                                }
                                                if -value.translation.width > 50 {
                                                    changeView(left: true)
                                                }
                                            }))
                    
                }
                
                NavigationLink(destination: NewChatView(),
                               isActive: self.$showNewChat) { EmptyView() }
                    .hidden()
            }
            .animation(.default)
            .padding(.vertical)
            .ignoresSafeArea(edges: .bottom)
            .navigationBarTitle("채팅", displayMode: .inline)
            .introspectTabBarController { (UITabBarController) in
                UITabBarController.tabBar.isHidden = false
                uiTabarController = UITabBarController
            }.onAppear {
                uiTabarController?.tabBar.isHidden = false
            }
        }
    }
    
    func changeView(left: Bool) {
        if left {
            if self.index != 3 {
                self.index += 1
            }
        } else {
            if self.index != 0 {
                self.index -= 1
            }
        }
        if self.index == 1 {
            self.offset = 0
        } else if self.index == 2 {
            self.offset = UIFrame.width
        } else {
            self.offset = UIFrame.width * 2
        }
    }
    
}

struct ChannelRow: View {
    let channel: Channel
    
    var body: some View {
        HStack(spacing: 7) {
            if channel.imageUrl == "placeholder" {
                ZStack {
                    Image("placeholder")
                        .frame(width: UIFrame.width / 8, height: UIFrame.width / 8)
                        .clipShape(Circle())
                    
                    Text("#").font(.title2)
                }
            } else {
                KFImage(URL(string: channel.imageUrl))
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: UIFrame.width / 8, height: UIFrame.width / 8)
            }
            
            VStack(alignment: .leading, spacing: 7) {
                HStack {
                    Text(channel.name)
                        .fontWeight(.bold)
                        .foregroundColor(Color(Asset.black))
                    Spacer()
                    Text(channel.lastMsgTime)
                        .foregroundColor(.gray)
                }
                Text(channel.lastMsg)
                    .foregroundColor(.gray)
                    .padding(.bottom, 5)
                
                Divider()
            }
        }
    }
}

struct ChatListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatListView()
    }
}
