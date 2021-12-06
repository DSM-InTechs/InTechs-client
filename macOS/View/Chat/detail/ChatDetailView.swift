//
//  DetailView.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/08/22.
//

import SwiftUI
import GEmojiPicker
import Kingfisher

struct ChatDetailView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    @EnvironmentObject var chatListVM: ChatListViewModel
    @StateObject var viewModel = ChatDetailViewModel()
    
    let channelId: String
    
    @State var isThread: Bool = false
    @State var selectedNoticeIndex: Int = 0
    @State var selectedThreadIndex: Int = 0
    
    @State private var emojiPop = false
    @State private var filePop = false
    @State private var notificationPop = false
    @State private var channelDotPop = false
    @State private var isBell = false
    
    var body: some View {
        GeometryReader { geo in
            HStack {
                VStack {
                    HStack(spacing: 10) {
                        KFImage(URL(string: viewModel.channel.image))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                        
                        Text(viewModel.channel.name)
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
                                    .environmentObject(viewModel)
                                    .environmentObject(chatListVM)
                            }
                        
                        Button(action: {
                            withAnimation {
                                homeVM.toast = .channelSearch(channelId: channelId)
                            }
                        }, label: {
                            Image(system: .search)
                                .font(.title2)
                        })
                            .buttonStyle(PlainButtonStyle())
                        
                        Button(action: {
                            withAnimation {
                                homeVM.toast = .channelInfo(channelId: channelId)
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
                                Image(system: .setting)
                                    .font(.title2)
                                Image(system: .filledDownArrow)
                                    .font(.caption)
                            }
                        }).buttonStyle(PlainButtonStyle())
                            .padding(.all, 5)
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.green.opacity(0.2)))
                            .popover(isPresented: $notificationPop) {
                                NotificationPopView()
                                    .environmentObject(chatListVM)
                                    .environmentObject(viewModel)
                                    .frame(width: 200)
                            }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    Divider()
                    
                    ZStack(alignment: .top) {
                        //                        VStack {
                        //                            Spacer(minLength: 0)
                        
                        MessageView(isThread: $isThread, messages: $viewModel.messageList, selectedThreadIndex: $selectedThreadIndex, selectedNoticeIndex: $selectedNoticeIndex)
                            .environmentObject(viewModel)
                        //                        }
                        
                        if viewModel.messageList.notice != nil {
                            NoticeMessageView(notice: viewModel.messageList.notice!)
                        }
                    }
                    
                    HStack(spacing: 15) {
                        Button(action: {
                            self.filePop.toggle()
                        }, label: {
                            Image(system: .clip)
                                .font(.title2)
                        }).buttonStyle(PlainButtonStyle())
                            .popover(isPresented: $filePop) {
                                FileTypeSelectView(selectedImage: $viewModel.selectedNSImages, selectedFile: $viewModel.selectedFile)
                                    .padding()
                            }
                        
                        VStack(alignment: .leading) {
                            if !viewModel.selectedFile.isEmpty {
                                LazyHStack {
                                    ForEach(0..<viewModel.selectedFile.count, id: \.self) { index in
                                        ZStack(alignment: .topTrailing) {
                                            HStack(spacing: 20) {
                                                Image(system: .clip)
                                                Text(viewModel.selectedFile[index].0)
                                                Spacer()
                                            }
                                            .padding()
                                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.gray).opacity(0.2))
                                            
                                            Image(system: .xmarkCircle)
                                                .foregroundColor(.gray)
                                                .onTapGesture {
                                                    self.viewModel.selectedFile.remove(at: index)
                                                }
                                        }
                                    }
                                }.padding(.horizontal, 10)
                                    .frame(height: 70)
                            }
                            
                            if !viewModel.selectedNSImages.isEmpty {
                                LazyHStack {
                                    ForEach(0..<viewModel.selectedNSImages.count, id: \.self) { index in
                                        ZStack(alignment: .topTrailing) {
                                            Image(nsImage: viewModel.selectedNSImages[index].1)
                                                .resizable()
                                                .frame(width: 75, height: 75)
                                            
                                            Image(system: .xmarkCircle)
                                                .foregroundColor(.gray)
                                                .onTapGesture {
                                                    self.viewModel.selectedNSImages.remove(at: index)
                                                }
                                        }
                                        
                                    }
                                }.padding(.horizontal, 10)
                                    .frame(height: 80)
                            }
                            
                            TextField("메세지를 입력하세요", text: $viewModel.text, onCommit: {
                                self.viewModel.apply(.sendMessage)
                            })
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding(.vertical, 8)
                                .padding(.horizontal)
                        }.background(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.white))
                        
                        Button(action: {
                            self.emojiPop.toggle()
                        }, label: {
                            Image(system: .smileFace)
                                .font(.title2)
                        }).buttonStyle(PlainButtonStyle())
                            .popover(isPresented: $emojiPop) {
                                EmojiPicker(emojiStore: EmojiStore(), selectionHandler: { self.viewModel.text.append($0.string) })
                                    .environmentObject(SharedState())
                                    .frame(width: 400, height: 300)
                            }
                    }
                    .padding([.horizontal, .bottom])
                    
                }
                
                if isThread {
                    TheadView(channelId: self.channelId, isThread: $isThread,
                              message: $viewModel.messageList.chats[selectedThreadIndex])
                        .frame(width: geo.size.width / 3)
                        .ignoresSafeArea(.all)
                        .background(Color(NSColor.systemGray).opacity(0.1))
                }
            }.padding(.trailing, 70)
        }
        .background(Color(NSColor.textBackgroundColor))
        .ignoresSafeArea(.all, edges: .all)
        .onAppear {
            self.viewModel.apply(.onAppear(channelId: channelId))
            self.viewModel.apply(.setMypage(profile: homeVM.profile))
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        Home().environmentObject(HomeViewModel())
        ChannelDotPopView(isShow: .constant(false))
        //        NotificationPopView(isOn: .constant(false))
    }
}

struct HoverImage: View {
    let system: SFImage
    var body: some View {
        Image(system: system)
            .font(.callout)
            .padding(.all, 5)
            .overlay(
                Rectangle().foregroundColor(.clear)
                    .border(Color.gray.opacity(0.2), width: 1)
            )
            .background(Color(NSColor.textBackgroundColor))
    }
}

struct FileTypeSelectView: View {
    @Binding var selectedImage: [(String, NSImage)]
    @Binding var selectedFile: [(String, Data)]
    
    var body: some View {
        VStack(spacing: 20) {
            Button(action: {
                NSOpenPanel.openFile(completion: { result in
                    switch result {
                    case .success(let tuple):
                        self.selectedFile.append(tuple)
                    case .failure(_):
                        break
                    }
                })
            }, label: {
                HStack {
                    Image(systemName: "doc.text")
                    Text("파일")
                    Spacer()
                }.font(.title3)
            }).buttonStyle(PlainButtonStyle())
            
            Button(action: {
                NSOpenPanel.openImage(completion: { result in
                    switch result {
                    case .success(let tuple):
                        self.selectedImage.append(tuple)
                    default: break
                    }
                })
            }, label: {
                HStack {
                    Image(system: .photo)
                    Text("이미지")
                    Spacer()
                }.font(.title3)
            })
                .buttonStyle(PlainButtonStyle())
        }
    }
}

struct ChannelDotPopView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    @EnvironmentObject var chatListVM: ChatListViewModel
    @EnvironmentObject var viewModel: ChatDetailViewModel
    @Binding var isShow: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(system: .info)
                Text("채널 정보")
            }.onTapGesture {
                self.isShow = false
                withAnimation {
                    homeVM.toast = .channelInfo(channelId: viewModel.channel.id)
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
                        homeVM.toast = .channelRename(channel: viewModel.channel, execute: {
                            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5, execute: {
                                chatListVM.apply(.onAppear)
                                viewModel.apply(.getChatInfo)
                            })
                        })
                    }
                }
                
                HStack {
                    Image(system: .bellSlash)
                    Text("채널 탈퇴")
                }.foregroundColor(.red)
                    .onTapGesture {
                        self.isShow = false
                        withAnimation {
                            homeVM.toast = .channelExit(channel: viewModel.channel, execute: {
                                DispatchQueue.global().asyncAfter(deadline: .now() + 0.5, execute: {
                                    chatListVM.apply(.onAppear)
                                })
                            })
                        }
                    }
                
                HStack {
                    Image(system: .trash)
                    Text("채널 삭제")
                }.foregroundColor(.red)
                    .onTapGesture {
                        self.isShow = false
                        withAnimation {
                            homeVM.toast = .channelDelete(channel: viewModel.channel, execute: {
                                DispatchQueue.global().asyncAfter(deadline: .now() + 0.5, execute: {
                                    chatListVM.apply(.onAppear)
                                })
                            })
                        }
                    }
            }
        }.padding()
    }
}

struct NotificationPopView: View {
    //    @Binding var isOn: Bool
    @EnvironmentObject var chatListVM: ChatListViewModel
    @EnvironmentObject var viewModel: ChatDetailViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("푸시 알림 받기")
                    .font(.title3)
                Spacer()
                Toggle("", isOn: $viewModel.channel.notification)
                    .toggleStyle(SwitchToggleStyle())
                    .onChange(of: viewModel.channel.notification) {
                        viewModel.apply(.changeNotification(isOn: $0))
                    }
            }
            
            Divider()
            
            HStack {
                Text("나가기")
                    .foregroundColor(.red)
            }.onTapGesture {
                //                self.chatListVM.exitChannel()
            }
            
        }.padding()
    }
}

struct NoticeMessageView: View {
    @State private var isExtend: Bool = false
    let notice: ChatMessage
    
    var body: some View {
        Group {
            if isExtend {
                Group {
                    VStack(alignment: .leading) {
                        HStack(spacing: 20) {
                            Image(system: .speaker)
                            Text(notice.message)
                            Spacer()
                            
                            Image(system: .downArrow)
                                .onTapGesture {
                                    self.isExtend.toggle()
                                }
                        }
                        
                        HStack {
                            Text(notice.sender.name)
                            Text("등록")
                        }.foregroundColor(.gray)
                    }.padding()
                        .background(Color.background)
                    
                }.padding(.horizontal, 10)
            } else {
                Group {
                    HStack(spacing: 20) {
                        Image(system: .speaker)
                        Text(notice.message)
                        Spacer()
                        
                        Image(system: .downArrow)
                            .onTapGesture {
                                self.isExtend.toggle()
                            }
                    }.padding()
                        .background(Color.background)
                }.padding(.horizontal, 10)
            }
        }
    }
}
