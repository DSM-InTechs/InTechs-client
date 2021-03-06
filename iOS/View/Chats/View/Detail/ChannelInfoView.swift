//
//  ChannelInfoView.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/27.
//

import SwiftUI
import Kingfisher

struct ChannelInfoView: View {
    let channel: ChatRoom
    @ObservedObject var viewModel = ChannelInfoViewModel()
    
    @State private var isExit: Bool = false
    @State private var isDelete: Bool = false
    
    var body: some View {
        ZStack {
            Color(UIColor.secondarySystemBackground)
                .ignoresSafeArea()
            
            GeometryReader { _ in
                VStack(spacing: UIFrame.width / 10) {
                    NavigationLink(destination: ChannelEditView()) {
                        HStack {
                            KFImage(URL(string: channel.imageURL))
                                .resizable()
                                .clipShape(Circle())
                                .frame(width: 50, height: 50)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text(channel.name)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(Asset.black))
                                Text("편집")
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                    }.padding(.top)
                    
                    if viewModel.channel.notification == true {
                        NavigationLink(destination: ChannelNotificationView().environmentObject(viewModel)) {
                            MypageRow(title: "알림", _body: "OFF", image: .bell)
                        }
                    } else {
                        NavigationLink(destination: ChannelNotificationView().environmentObject(viewModel)) {
                            MypageRow(title: "알림", _body: "ON", image: .bell)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 3) {
                        NavigationLink(destination: ChannelMemberView().environmentObject(viewModel)) {
                            MypageRow(title: "멤버", _body: "", image: .person)
                        }
                        
                        NavigationLink(destination: ChannelPinnedView().environmentObject(viewModel)) {
                            MypageRow(title: "공지사항", _body: "", image: .pin)
                        }
                        
                        NavigationLink(destination: ChannelMediaView().environmentObject(viewModel)) {
                            MypageRow(title: "공유함", _body: "", image: .camera)
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Button(action: {
                            self.isExit = true
                        }, label: {
                            MypageRow(title: "채널 나가기", _body: "", image: .bellSlash, isRightArrow: false)
                                .accentColor(.red)
                        })
                    }
                }.padding()
            }
            .navigationBarTitle("채널 정보")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: {
                            self.isDelete = true
                        }) {
                            HStack {
                                Image(system: .trash)
                                Text("채널 삭제")
                            }
                        }.foregroundColor(Color.red)
                    }
                    label: {
                        Image(system: .dot)
                            .rotationEffect(.degrees(90))
                    }
                }
            }.alert(isPresented: $isExit) {
                Alert(title: Text("채널에서 나가시겠습니까?"), primaryButton: .destructive(Text("예"), action: {
                    // Some action
                }), secondaryButton: .cancel())
            }
        }.onAppear {
            self.viewModel.apply(.onAppear(channelId: self.channel.id))
        }
    }
}

struct ChannelNotificationView: View {
    @EnvironmentObject var viewModel: ChannelInfoViewModel
    
    var body: some View {
        ZStack {
            Color(UIColor.secondarySystemBackground)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 25) {
                    VStack {
                        VStack {
                            HStack {
                                Text("알림 허용")
                                Spacer()
                                Toggle("", isOn: .constant(true))
                            }
                            .padding(.all, 10)
                        }.background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(Asset.white)))
                    }
                    
                    VStack(alignment: .leading, spacing: 3) {
                        Text("메세지")
                            .foregroundColor(.gray)
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.bottom, 5)
                        
                        VStack {
                            HStack {
                                Text("모든 메세지")
                                Spacer()
                                Image(system: .checkmark)
                                    .font(.caption)
                                    .hidden()
                            }
                            .padding(.all, 15)
                        }.background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(Asset.white)))
                        
                        VStack {
                            HStack {
                                Text("언급만")
                                Spacer()
                                Image(system: .checkmark)
                                    .font(.caption)
                            }
                            .padding(.all, 15)
                        }.background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(Asset.white)))
                    }
                    
                    VStack(alignment: .leading) {
                        Text("설정")
                            .foregroundColor(.gray)
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.bottom, 5)
                        
                        VStack {
                            HStack {
                                Text("푸시 알람 허용")
                                Spacer()
                                Toggle("", isOn: .constant(true))
                            }
                            .padding(.all, 10)
                        }.background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(Asset.white)))
                    }
                }.padding()
                .navigationBarTitle("알림")
            }
        }
    }
}

struct ChannelMemberView: View {
    @EnvironmentObject var viewModel: ChannelInfoViewModel
    @State private var isInvite: Bool = false
    
    var body: some View {
        ZStack {
            Color(UIColor.secondarySystemBackground)
                .ignoresSafeArea()
            
            NavigationLink(destination: ChannelInviteMemberView(),
                           isActive: self.$isInvite) { EmptyView() }
                .hidden()
            
            ScrollView {
                VStack(spacing: 10) {
                    Group {
                        TextField("Search", text: .constant(""))
                            .padding(.all, 10)
                            .background(Color.gray).opacity(0.2).cornerRadius(10)
                    }.padding(.vertical, 10)
                    
                    LazyVStack {
                        ForEach(viewModel.channel.users, id: \.self) { user in
                            HStack(spacing: 10) {
                                KFImage(URL(string: user.imageURL))
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                
                                Text(user.name)
                                
                                Spacer()
                            }.padding()
                            Divider()
                        }.background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(Asset.white)))
                    }
                }.padding()
                .navigationBarTitle("멤버")
                .navigationBarItems(trailing:
                                        Image(system: .plus)
                                        .onTapGesture {
                                            self.isInvite = true
                                        }
                                        .foregroundColor(.blue)
                )
            }
        }
    }
}

struct ChannelInviteMemberView: View {
    var body: some View {
        ZStack {
            Color(UIColor.secondarySystemBackground)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 10) {
                    Group {
                        TextField("Search", text: .constant(""))
                            .padding(.all, 10)
                            .background(Color.gray).opacity(0.2).cornerRadius(10)
                    }.padding(.vertical, 10)
                    
                    LazyVStack(spacing: 0) {
                        ForEach(0...1, id: \.self) { _ in
                            HStack(spacing: 10) {
                                Circle().frame(width: 50, height: 50)
                                Text("사람 이름")
                                Spacer()
                                Image(system: .circle)
                            }.padding()
                            Divider()
                        }.background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(Asset.white)))
                    }
                }.padding()
                .navigationBarItems(trailing: Text("추가"))
            }
        }
    }
}

struct ChannelPinnedView: View {
    @EnvironmentObject var viewModel: ChannelInfoViewModel
    
    var body: some View {
        ZStack {
            Color(UIColor.secondarySystemBackground)
                .ignoresSafeArea()
            
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.notices, id: \.self) { notice in
                        PinnedMessageView(name: notice.name, _body: notice.message, time: notice.time)
                            .padding(.all, 10)
                        Divider()
                    }.background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(Asset.white)))
                }
                .navigationBarTitle("공지사항")
            }
        }.onAppear {
            self.viewModel.apply(.getNotices)
        }
    }
}

struct PinnedMessageView: View {
    let name: String
    let _body: String
    let time: String
    
    var body: some View {
        VStack {
            HStack(spacing: 10) {
                Circle().frame(width: 40, height: 40)
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(name)
                            .fontWeight(.bold)
                        Spacer()
                        Text(time)
                            .foregroundColor(.gray)
                    }
                    
                    Text(_body)
                }
            }
        }
        
    }
}

struct ChannelMediaView: View {
    @EnvironmentObject var viewModel: ChannelInfoViewModel
    @State var selectedTab: Int = 0 // 0 : 이미지, 1: 파일
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if selectedTab == 0 {
                    Text("이미지")
                        .padding(.all, 5)
                        .padding(.horizontal, 5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(Asset.black), lineWidth: 2)
                        )
                    
                    Text("파일")
                        .padding(.all, 5)
                        .padding(.horizontal, 5)
                        .foregroundColor(.gray)
                        .onTapGesture {
                            self.selectedTab = 1
                        }
                } else {
                    Text("이미지")
                        .padding(.all, 5)
                        .padding(.horizontal, 5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(Asset.black), lineWidth: 2)
                        ).onTapGesture {
                            self.selectedTab = 0
                        }
                    
                    Text("파일")
                        .padding(.all, 5)
                        .padding(.horizontal, 5)
                        .foregroundColor(.gray)
                }
            }.padding(.all, 5)
            .padding(.horizontal)
            
            ZStack(alignment: .top) {
                Color(UIColor.secondarySystemBackground)
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("2021 8월")
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .foregroundColor(.gray)
                    HStack {
                        Rectangle().foregroundColor(.gray).frame(width: UIFrame.width / 3, height: UIFrame.width / 3)
                        Rectangle().foregroundColor(.gray).frame(width: UIFrame.width / 3, height: UIFrame.width / 3)
                        Rectangle().foregroundColor(.gray).frame(width: UIFrame.width / 3, height: UIFrame.width / 3)
                    }
                }.padding(.top, 10)
            }
        }.padding(.top, 10)
            .onAppear {
                self.viewModel.apply(.getFiles)
            }
    }
}

struct ChannelInfoView_Previews: PreviewProvider {
    static var previews: some View {
//        ChannelInfoView()
//        ChannelMemberView()
//        ChannelInviteMemberView()
        ChannelNotificationView()
//        ChannelPinnedView()
//        ChannelMediaView()
    }
}
