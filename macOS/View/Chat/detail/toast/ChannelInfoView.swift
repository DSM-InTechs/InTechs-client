//
//  ChannelInfoView.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/08/23.
//

import SwiftUI
import Kingfisher

enum ChannelInfoTab: String {
    case subscribers = "멤버"
    case pinned = "공지사항"
    case media = "공유첩"
}

struct ChannelInfoView: View {
    let id: String
    
    @ObservedObject var viewModel = ChannelInfoViewModel()
    @State private var hover = false
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 25) {
                HStack {
                    HStack {
                        if hover {
                            ZStack {
                                Circle().foregroundColor(.black.opacity(0.9)).frame(width: geo.size.width / 8, height: geo.size.width / 8)
                                
                                Image(system: .photo)
                            }
                        } else {
                            Circle().frame(width: geo.size.width / 8, height: geo.size.width / 8)
                        }
                        Text(viewModel.channel.name)
                    }.onHover(perform: { hovering in
                        self.hover = hovering
                    })
                    
                    Spacer()
                }
                VStack(spacing: -1) {
                    HStack(spacing: 0) {
                        ChannelInfoTabButton(tab: .subscribers, number: viewModel.channel.users.count, selectedTab: $viewModel.selectedTab)
                            .frame(width: geo.size.width / 4)
                        
                        ChannelInfoTabButton(tab: .pinned, number: viewModel.notices.count, selectedTab: $viewModel.selectedTab)
                            .frame(width: geo.size.width / 4)
                        
                        ChannelInfoTabButton(tab: .media, number: 0, selectedTab: $viewModel.selectedTab)
                            .frame(width: geo.size.width / 4)
                        
                        Spacer()
                    }
                    Divider()
                }
                
                switch viewModel.selectedTab {
                case .subscribers:
                    ChannelSubscribersView(members: viewModel.channel.users, text: $viewModel.userEmail)
                        .environmentObject(viewModel)
                case .pinned:
                    ChannelPinnedView(notices: viewModel.notices)
                case .media:
                    ChannelMediaView()
                }
            }.padding()
                .padding(.all, 10)
                .onAppear {
                    self.viewModel.apply(.onAppear(channelId: id))
                }
        }
    }
}

struct ChannelInfoTabButton: View {
    var tab: ChannelInfoTab
    var number: Int
    @Binding var selectedTab: ChannelInfoTab
    
    var body: some View {
        ZStack {
            Button(action: {
                withAnimation {
                    selectedTab = tab
                }
            }, label: {
                VStack(spacing: 7) {
                    HStack {
                        Text(tab.rawValue)
                        Text(String(number))
                    }
                    
                    if selectedTab == tab {
                        Color.white.frame(height: 2)
                    } else {
                        Divider()
                    }
                }
            })
                .buttonStyle(PlainButtonStyle())
        }
    }
}

struct ChannelSubscribersView: View {
    let members: [RoomUser]
    @Binding var text: String
    
    @EnvironmentObject var viewModel: ChannelInfoViewModel
    
    var body: some View {
        VStack {
            TextField("멤버 추가하기", text: $text, onCommit: {
                viewModel.apply(.addUser)
            })
                .textFieldStyle(PlainTextFieldStyle())
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color.gray.opacity(0.3))
                )
            
            ScrollView {
                LazyVStack {
                    ForEach(members, id: \.self) { member in
                        HStack(spacing: 10) {
                            KFImage(URL(string: member.imageURL))
                                .resizable()
                                .clipShape(Circle())
                                .frame(width: 30, height: 30)
                            
                            Text(member.name)
                            
                            Spacer()
                        }.padding(.all, 10)
                    }
                }
            }
        }
    }
}

struct ChannelPinnedView: View {
    let notices: [ChatNotice]
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(notices, id: \.self) { notice in
                    HStack(spacing: 10) {
                        Circle().frame(width: 30, height: 30)
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text(notice.name)
                                    .fontWeight(.bold)
                                Text(notice.time)
                                    .foregroundColor(.gray)
                            }
                            
                            Text(notice.message)
                        }
                        
                        Spacer()
                    }.padding(.all, 10)
                }
            }
        }
    }
}

struct ChannelMediaView: View {
    @State var selectedTab: Int = 0
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 10) {
                    if selectedTab == 0 {
                        Text("이미지")
                            .padding(.all, 5)
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.black).opacity(0.7))
                    } else {
                        Text("이미지")
                            .padding(.all, 5)
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.gray.opacity(0.5)))
                            .onTapGesture {
                                selectedTab = 1
                            }
                    }
                    
                    if selectedTab == 1 {
                        Text("파일")
                            .padding(.all, 5)
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.black).opacity(0.7))
                    } else {
                        Text("파일")
                            .padding(.all, 5)
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.gray.opacity(0.5)))
                            .onTapGesture {
                                selectedTab = 1
                            }
                    }
                    
                    Spacer()
                }
                
                VStack(alignment: .leading) {
                    Text("2021 July")
                        .foregroundColor(.gray)
                    
                    HStack(spacing: 10) {
                        RoundedRectangle(cornerRadius: 10).frame(width: geo.size.height / 3, height: geo.size.height / 3)
                        
                        RoundedRectangle(cornerRadius: 10).frame(width: geo.size.height / 3, height: geo.size.height / 3)
                    }
                }
            }
        }
    }
}

//struct ChannelInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChannelInfoView()
//        ChannelSubscribersView(text: .constant(""))
//        ChannelPinnedView()
//    }
//}
