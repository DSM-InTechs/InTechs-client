//
//  ChannelInfoView.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/08/23.
//

import SwiftUI

enum ChannelInfoTab: String {
    case Subscribers = "멤버"
    case Pinned = "공지사항"
    case Media = "공유첩"
}

struct ChannelInfoView: View {
    @State var selectedTab: ChannelInfoTab = .Subscribers
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
                        Text("채널 이름")
                    }.onHover(perform: { hovering in
                        self.hover = hovering
                    })
                    
                    Spacer()
                }
                VStack(spacing: -1) {
                    HStack(spacing: 0) {
                        ChannelInfoTabButton(tab: .Subscribers, number: .constant(4), selectedTab: $selectedTab)
                            .frame(width: geo.size.width / 4)
                        
                        ChannelInfoTabButton(tab: .Pinned, number: .constant(1), selectedTab: $selectedTab)
                            .frame(width: geo.size.width / 4)
                        
                        ChannelInfoTabButton(tab: .Media, number: .constant(nil), selectedTab: $selectedTab)
                            .frame(width: geo.size.width / 4)
                        
                        Spacer()
                    }
                    Divider()
                }
                
                switch selectedTab {
                case .Subscribers:
                    ChannelSubscribersView(text: .constant(""))
                case .Pinned:
                    ChannelPinnedView()
                case .Media:
                    ChannelMediaView()
                }
            }.padding()
        }
    }
}

struct ChannelInfoTabButton: View {
    var tab: ChannelInfoTab
    @Binding var number: Int?
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
                        if number != nil {
                            Text(String(number!))
                        }
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
    @Binding var text: String
    var body: some View {
        VStack {
            TextField("멤버 추가하기", text: $text)
                .textFieldStyle(PlainTextFieldStyle())
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color.gray.opacity(0.3))
                )
            
            ScrollView {
                LazyVStack {
                    ForEach(0...3, id: \.self) { _ in
                        HStack(spacing: 10) {
                            Circle().frame(width: 30, height: 30)
                            Text("이름")
                            Spacer()
                        }.padding(.all, 10)
                    }
                }
            }
        }
    }
}

struct ChannelPinnedView: View {
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(0...0, id: \.self) { _ in
                    HStack(spacing: 10) {
                        Circle().frame(width: 30, height: 30)
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("이름")
                                    .fontWeight(.bold)
                                Text("9월 29일 03:13")
                                    .foregroundColor(.gray)
                            }
                            
                            Text("채팅 내용")
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

struct ChannelInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ChannelInfoView()
        ChannelSubscribersView(text: .constant(""))
        ChannelPinnedView()
    }
}
