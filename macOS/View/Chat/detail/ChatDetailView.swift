//
//  DetailView.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/08/22.
//

import SwiftUI
import GEmojiPicker

struct ChatDetailView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    var user: RecentMessage
    @State private var emojiPop = false
    @State private var filePop = false
    @State private var notificationPop = false
    @State private var channelDotPop = false
    @State private var isBell = false
    
    var body: some View {
        GeometryReader { geo in
                    VStack {
                        HStack(spacing: 10) {
                            Image(user.userImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                            
                            Text(user.userName)
                                .font(.title2)
                            
                            Spacer()
                            
                            Button(action: {
                                withAnimation {
                                    self.channelDotPop.toggle()
                                }
                            }, label: {
                                Image(system: .dot)
                                    .font(.title2)
                            })
                            .buttonStyle(PlainButtonStyle())
                            .popover(isPresented: $channelDotPop) {
                                ChannelDotPopView(isShow: $channelDotPop)
                                    .frame(width: 150)
                                    .environmentObject(homeVM)
                            }
                            
                            HStack(spacing: -10) {
                                Circle().frame(width: 20, height: 20)
                                Circle().frame(width: 20, height: 20)
                                Circle().frame(width: 20, height: 20)
                                Text("+5")
                                    .foregroundColor(.black)
                                    .font(.caption)
                                    .background(Circle().frame(width: 20, height: 20))
                            }.onTapGesture {
                                withAnimation {
                                    homeVM.toast = .channelInfo
                                }
                            }
                            
                            Button(action: {
                                withAnimation {
                                    homeVM.toast = .channelSearch
                                }
                            }, label: {
                                Image(system: .search)
                                    .font(.title2)
                            })
                            .buttonStyle(PlainButtonStyle())
                            
                            Button(action: {
                                withAnimation {
                                    homeVM.toast = .channelInfo
                                }
                            }, label: {
                                Image(system: .info)
                                    .font(.title2)
                            })
                            .buttonStyle(PlainButtonStyle())
                            
                            Button(action: {
                                self.notificationPop.toggle()
                            }, label: {
                                HStack(spacing: 3) {
                                Image(system: .bell)
                                    .font(.title2)
                                    Image(system: .filledDownArrow)
                                        .font(.caption)
                                }
                            }).buttonStyle(PlainButtonStyle())
                            .padding(.all, 5)
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.green.opacity(0.2)))
                            .popover(isPresented: $notificationPop) {
                                NotificationPopView(isOn: .constant(false))
                                    .frame(width: 200)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        
                        Divider()
                        
                        MessageView(user: user)
                        
                        HStack(spacing: 15) {
                            Button(action: {
                                self.filePop.toggle()
                            }, label: {
                                Image(system: .clip)
                                    .font(.title2)
                            }).buttonStyle(PlainButtonStyle())
                            .popover(isPresented: $filePop) {
                                FileTypeSelectView()
                                    .padding()
                            }
                            
                            TextField("Enter Message", text: $homeVM.message, onCommit: {
                                homeVM.sendMessage(user: user)
                            })
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(.vertical, 8)
                            .padding(.horizontal)
                            .clipShape(Capsule())
                            .background(Capsule().strokeBorder(Color.white))
                            
                            Button(action: {
                                self.emojiPop.toggle()
                            }, label: {
                                Image(system: .smileFace)
                                    .font(.title2)
                            }).buttonStyle(PlainButtonStyle())
                            .popover(isPresented: $emojiPop) {
                                EmojiPicker(emojiStore: EmojiStore(), selectionHandler: { _ in })
                                    .environmentObject(SharedState())
                                    .frame(width: geo.size.width / 2.2, height: geo.size.height / 2.5)
                            }
                            
                        }
                        .padding([.horizontal, .bottom])
                
            }
            .padding(.trailing, 70)
        }
        .background(Color(NSColor.textBackgroundColor))
        .ignoresSafeArea(.all, edges: .all)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        Home().environmentObject(HomeViewModel())
        ChannelDotPopView(isShow: .constant(false))
//        NotificationPopView(isOn: .constant(false))
    }
}

struct MessageView: View {
    @EnvironmentObject var homeData: HomeViewModel
    var user: RecentMessage
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                ScrollViewReader { proxy in
                    VStack(spacing: 18) {
                        ForEach(user.allMsgs) { message in
                            MessageRow(message: message, user: user, width: geo.frame(in: .global).width)
                                .tag(message.id)
                                .padding(.leading)
                        }
                        .onAppear {
                            let lastId = user.allMsgs.last!.id
                            
                            proxy.scrollTo(lastId, anchor: .bottom)
                        }
                        .onChange(of: user.allMsgs, perform: { _ in
                            let lastId = user.allMsgs.last!.id
                            
                            proxy.scrollTo(lastId, anchor: .bottom)
                        })
                    }
                    .padding(.bottom, 30)
                }
            }
        }
    }
}

struct MessageRow: View {
    var message: Message
    var user: RecentMessage
    var width: CGFloat
    
    var body: some View {
        HStack(spacing: 10) {
            HStack {
                Image(user.userImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 35, height: 35)
                    .clipShape(Circle())
                
                VStack(alignment: .leading) {
                    HStack {
                        Text(user.userName)
                        Text("10: 10")
                    }
                    
                    Text(message.message)
                        .foregroundColor(.white)
                        .frame(width: width, alignment: .leading)
                }
            }
        }
    }
}

struct FileTypeSelectView: View {
    var body: some View {
        VStack(spacing: 20) {
            Button(action: {
                
            }, label: {
                HStack {
                    Image(systemName: "doc.text")
                    Text("File")
                    Spacer()
                }.font(.title3)
            }).buttonStyle(PlainButtonStyle())
            
            Button(action: {
                NSOpenPanel.openImage(completion: { _ in
                    
                })
            }, label: {
                HStack {
                    Image(system: .photo)
                    Text("Image or Video")
                    Spacer()
                }.font(.title3)
            })
            .buttonStyle(PlainButtonStyle())
        }
    }
}

struct ChannelDotPopView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    @Binding var isShow: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(system: .info)
                Text("채널 정보")
            }.onTapGesture {
                self.isShow = false
                withAnimation {
                    homeVM.toast = .channelInfo
                }
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Image(system: .pencil)
                    Text("채널명 바꾸기")
                }.onTapGesture {
                    self.isShow = false
                    withAnimation {
                        homeVM.toast = .channelRename
                    }
                }
                
                HStack {
                    Image(system: .trash)
                    Text("채널 삭제")
                }.foregroundColor(.red)
                .onTapGesture {
                    self.isShow = false
                    withAnimation {
                        homeVM.toast = .channelDelete
                    }
                }
            }
        }.padding()
    }
}

struct NotificationPopView: View {
    @Binding var isOn: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("알림")
                    .font(.title3)
                Spacer()
                Toggle("", isOn: $isOn).toggleStyle(SwitchToggleStyle())
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Image(system: .circleFill)
                        .foregroundColor(.blue)
                    Text("모든 메세지")
                }
                
                HStack {
                    Image(system: .circle)
                    Text("언급만")
                }
            }
            
            Divider()
            
            HStack {
                Image(system: .checklist)
                    .foregroundColor(.blue)
                Text("푸시 알람 받기")
            }
            
            Divider()
            
            HStack {
                Text("나가기")
                    .foregroundColor(.red)
            }
            
        }.padding()
    }
}
