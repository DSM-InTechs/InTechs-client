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
    
    @State var uiTabarController: UITabBarController?
    @EnvironmentObject var viewModel: ChatListViewModel
    
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
                                ForEach(viewModel.homes, id: \.self) { channel in
                                    NavigationLink(destination: ChatDetailView(channel: channel, title: channel.name)) {
                                        ChannelRow(channel: channel)
                                            .padding(.all, 10)
                                    }
                                    
                                }
                            }
                        }
                        .frame(width: geo.frame(in: .global).width)
                        
                        // Second View
                        VStack {
                            LazyVStack {
                                ForEach(viewModel.channels, id: \.self) { channel in
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
                                ForEach(viewModel.DMs, id: \.self) { channel in
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
            }
            .animation(.default)
            .padding(.vertical)
            .ignoresSafeArea(edges: .bottom)
            .navigationBarTitle("채팅", displayMode: .inline)
            .introspectTabBarController { (UITabBarController) in
                UITabBarController.tabBar.isHidden = false
                uiTabarController = UITabBarController
            }.onAppear {
                UINavigationBar.appearance().barTintColor = Asset.white.color
                uiTabarController?.tabBar.isHidden = false
                self.viewModel.apply(.onAppear)
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
    let channel: ChatRoom
    
    var body: some View {
        HStack(spacing: 7) {
            KFImage(URL(string: channel.imageURL))
                .resizable()
                .clipShape(Circle())
                .frame(width: UIFrame.width / 8, height: UIFrame.width / 8)
            
            VStack(alignment: .leading, spacing: 7) {
                HStack {
                    Text(channel.name)
                        .fontWeight(.bold)
                        .foregroundColor(Color(Asset.black))
                    Spacer()
                    Text(channel.time.prefix(10).suffix(5))
                        .foregroundColor(.gray)
                }
                Text(channel.message)
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
