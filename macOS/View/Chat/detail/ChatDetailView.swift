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
    
    @State var isThread: Bool = false
    @State var selectedMessageIndex: Int = 0
    @Binding var channel: Channel
    
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
                        if channel.imageUrl == "placeholder" {
                            ZStack {
                                Image(channel.imageUrl)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                
                                Text("#")
                                    .foregroundColor(.gray)
                                    .font(.title2)
                            }
                        } else {
                            KFImage(URL(string: channel.imageUrl))
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        }
                        
                        Text(channel.name)
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
                                Image(system: .setting)
                                    .font(.title2)
                                Image(system: .filledDownArrow)
                                    .font(.caption)
                            }
                        }).buttonStyle(PlainButtonStyle())
                            .padding(.all, 5)
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.green.opacity(0.2)))
                            .popover(isPresented: $notificationPop) {
                                NotificationPopView(isOn: $channel.isNotification)
                                    .environmentObject(chatListVM)
                                    .frame(width: 200)
                            }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    Divider()
                    
                    ZStack(alignment: .top) {
                        MessageView(isThread: $isThread, channel: $channel, selectedMessageIndex: $selectedMessageIndex)
                            .environmentObject(viewModel)
                        
                        if !channel.notices.isEmpty {
                            NoticeMessageView(notices: channel.notices)
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
                                FileTypeSelectView(selectedImage: $viewModel.selectedNSImages)
                                    .padding()
                            }
                        
                        VStack(alignment: .leading) {
                            if !viewModel.selectedNSImages.isEmpty {
                                LazyHStack {
                                    ForEach(0..<viewModel.selectedNSImages.count, id: \.self) { index in
                                        ZStack(alignment: .topTrailing) {
                                            Image(nsImage: viewModel.selectedNSImages[index])
                                                .resizable()
                                                .frame(width: 75, height: 75)
                                            
                                            Image(system: .xmarkCircle)
                                                .foregroundColor(.gray)
                                                .onTapGesture {
                                                    self.viewModel.selectedNSImages.remove(at: index)
                                                }
                                        }
                                        
                                    }
                                }
                            }
                            
                            TextField("메세지를 입력하세요", text: $viewModel.text, onCommit: {
                                if !viewModel.selectedNSImages.isEmpty {
                                    self.channel.allMsgs.append(Message(message: "http://www.thedroidsonroids.com/wp-content/uploads/2016/02/Rx_Logo_M-390x390.png", type: "IMAGE", isMine: true, sender: user1, time: "오후 11:10"))
                                }
                                
                                self.channel.allMsgs.append(Message(message: viewModel.text, type: "TALK", isMine: true, sender: user1, time: "오후 11:10"))
                                
                                self.viewModel.text = ""
                                self.viewModel.selectedNSImages = []
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
                    TheadView(isThread: $isThread,
                              message: channel.allMsgs[selectedMessageIndex])
                        .frame(width: geo.size.width / 3)
                        .ignoresSafeArea(.all)
                        .background(Color(NSColor.systemGray).opacity(0.1))
                }
            }.padding(.trailing, 70)
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
    @Binding var selectedImage: [NSImage]
    
    var body: some View {
        VStack(spacing: 20) {
            Button(action: {
                NSOpenPanel.openImage(completion: { _ in
                    
                })
            }, label: {
                HStack {
                    Image(systemName: "doc.text")
                    Text("File")
                    Spacer()
                }.font(.title3)
            }).buttonStyle(PlainButtonStyle())
            
            Button(action: {
                NSOpenPanel.openImage(completion: { result in
                    switch result {
                    case .success(let image):
                        self.selectedImage.append(image)
                    default: break
                    }
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
    @EnvironmentObject var chatListVM: ChatListViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("푸시 알림 받기")
                    .font(.title3)
                Spacer()
                Toggle("", isOn: $isOn).toggleStyle(SwitchToggleStyle())
            }
            
            Divider()
            
            HStack {
                Text("나가기")
                    .foregroundColor(.red)
            }.onTapGesture {
                self.chatListVM.exitChannel()
            }
            
        }.padding()
    }
}

struct NoticeMessageView: View {
    @State private var isExtend: Bool = false
    let notices: [Message]
    
    var body: some View {
        Group {
            if isExtend {
                Group {
                    VStack(alignment: .leading) {
                        HStack(spacing: 20) {
                            Image(system: .speaker)
                            Text(notices.first!.message)
                            Spacer()
                            
                            Image(system: .downArrow)
                                .onTapGesture {
                                    self.isExtend.toggle()
                                }
                        }
                        
                        HStack {
                            Text(notices.first!.sender.name)
                            Text("등록")
                        }.foregroundColor(.gray)
                    }.padding()
                        .background(Color.background)
                   
                }.padding(.horizontal, 10)
            } else {
                Group {
                    HStack(spacing: 20) {
                        Image(system: .speaker)
                        Text(notices.first!.message)
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
