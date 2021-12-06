//
//  MessageView.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/11/23.
//

import SwiftUI
import GEmojiPicker
import Kingfisher

struct MessageView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    @EnvironmentObject var viewModel: ChatDetailViewModel
    @Binding var isThread: Bool
    @Binding var messages: MessageList
    @Binding var selectedThreadIndex: Int
    @Binding var selectedNoticeIndex: Int
    
    var body: some View {
        ScrollView {
            ScrollViewReader { proxy in
                VStack(spacing: 18) {
                    Spacer(minLength: 0)
                    //                        Group {
                    //                            DateMessageView(date: "2021년 11월 30일")
                    //                                .padding(.horizontal)
                    //                        }
                    
                    ForEach(0..<messages.chats.count, id: \.self) { index in
                        MessageRow(message: $messages.chats[index],
                                   messagePinSelected: { self.selectedNoticeIndex = index },
                                   threadSelected: { self.selectedThreadIndex = index },
                                   isThread: $isThread)
                            .environmentObject(homeVM)
                            .environmentObject(viewModel)
                            .id(messages.chats[index].id)
                            .padding(.leading)
                    }
                    .onAppear {
                        let lastId = messages.chats.last!.id
                        
                        proxy.scrollTo(lastId, anchor: .bottom)
                    }
                    .onChange(of: messages.chats, perform: { _ in
                        let lastId = messages.chats.last!.id
                        
                        proxy.scrollTo(lastId, anchor: .bottom)
                    })
                }
                .padding(.bottom, 30)
            }
        }
    }
}

struct MessageRow: View {
    @EnvironmentObject var detailVM: ChatDetailViewModel
    @EnvironmentObject var homeVM: HomeViewModel
    @ObservedObject var viewModel = MessageViewModel()
    
    @Binding var message: ChatMessage
    let messagePinSelected: () -> Void
    let threadSelected: () -> Void
    @Binding var isThread: Bool
    
    @State private var hover: Bool = false
    @State private var isEditing: Bool = false
    @State private var profileHover: Bool = false
    @State private var emojiPop = false
    
    var body: some View {
        ZStack {
            if message.chatType == MessageType.talk.rawValue {
                VStack {
                    HStack(alignment: .top, spacing: 10) {
                        VStack {
                            KFImage(URL(string: message.sender.imageURL))
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 35, height: 35)
                                .clipShape(Circle())
                                .onHover(perform: { hovering in
                                    self.profileHover = hovering
                                })
                        }
                        
                        VStack(alignment: .leading, spacing: 3) {
                            HStack(spacing: 10) {
                                Text(message.sender.name)
                                Text(message.time.replacingOccurrences(of: "T", with: "  ").prefix(20).suffix(15))
                                    .foregroundColor(.gray)
                                Spacer()
                            }
                            
                            if isEditing {
                                VStack(spacing: 10) {
                                    HStack {
                                        
                                        TextField("", text: $detailVM.editingText, onCommit: {
                                            self.isEditing = false
                                            //                                        homeVM.sendMessage(channel: channel)
                                        })
                                            .textFieldStyle(PlainTextFieldStyle())
                                            .padding(.vertical, 8)
                                            .padding(.horizontal)
                                            .background(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.white))
                                    }
                                    
                                    HStack {
                                        Text("취소")
                                            .padding(.all, 5)
                                            .padding(.horizontal, 10)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color(Asset.black), lineWidth: 1)
                                            )
                                            .onTapGesture {
                                                withAnimation {
                                                    self.isEditing = false
                                                }
                                            }
                                        Spacer()
                                        Text("확인")
                                            .padding(.all, 5)
                                            .padding(.horizontal, 10)
                                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.blue))
                                            .onTapGesture {
                                                self.detailVM.apply(.updateChat(messageId: message.id))
                                                withAnimation {
                                                    self.isEditing = false
                                                }
                                            }
                                    }
                                    .padding(.bottom)
                                }
                            } else {
                                HStack {
                                    if message.delete == true {
                                        Text("(이 메세지는 삭제되었습니다.)")
                                            .foregroundColor(.gray)
                                        Spacer()
                                    } else {
                                        Text(message.message)
                                            .foregroundColor(.white)
                                            .fixedSize(horizontal: false, vertical: true)
                                        Spacer()
                                    }
                                }
                            }
                            
                            //                            LazyHStack {
                            //                                ForEach(message.emoticons.keys.sorted(), id: \.self) { key in
                            //                                    HStack(spacing: 10) {
                            //                                        Text(key)
                            //                                        Text(String(message.emoticons[key] ?? 1))
                            //                                    }
                            //                                    .padding(.all, 5)
                            //                                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.gray).opacity(0.2))
                            //                                }.padding(.top, 7)
                            //                            }
                            
                            if !message.threads.isEmpty && !isEditing {
                                HStack {
                                    KFImage(URL(string: message.threads.last!.sender.imageURL))
                                        .resizable()
                                        .clipShape(Circle())
                                        .frame(width: 15, height: 15)
                                    
                                    Text("\(message.threads.count)개의 답글")
                                        .foregroundColor(.white)
                                    
                                    Text(message.time.replacingOccurrences(of: "T", with: "  ").prefix(20).suffix(15))
                                        .foregroundColor(.gray)
                                    Spacer()
                                }
                                .padding(.vertical, 5)
                                .padding(.leading)
                                .background(Color.gray.opacity(0.1).cornerRadius(10))
                                .onTapGesture {
                                    withAnimation {
                                        self.isThread = true
                                        threadSelected()
                                    }
                                }
                            }
                        }.padding(.trailing)
                            .onHover(perform: { hovering in
                                if !self.emojiPop { // 이모티콘 판업 중일 경우에는 XX
                                    self.hover = hovering
                                }
                                
                                if isEditing {
                                    self.hover = false
                                }
                            })
                    }
                }
            } else if message.chatType == MessageType.info.rawValue {
                EnterExitMessageView(message: message)
            } else if message.chatType == MessageType.file.rawValue {
                FileMessageView(message: message)
            } else if message.chatType == MessageType.image.rawValue {
                ImageMessageView(message: message)
            }
            
            Spacer()
            
            if self.hover {
                HStack {
                    Spacer(minLength: 0)
                    HStack(spacing: 0) {
                        if message.sender.email == detailVM.userEmail {
                            HoverImage(system: .trash)
                                .onTapGesture {
                                    withAnimation {
                                        self.homeVM.toast = .messageDelete(execute: {
                                            self.detailVM.apply(.deleteChat(messageId: message.id))
                                        })
                                    }
                                }
                            HoverImage(system: .pencil)
                                .onTapGesture {
                                    self.detailVM.apply(.editText(preText: message.message))
                                    withAnimation {
                                        self.isEditing = true
                                    }
                                }
                        }
                        
                        HoverImage(system: .pin)
                            .onTapGesture {
                                viewModel.apply(.setNotice(messageId: self.message.id))
                                messagePinSelected()
                            }
                        
                        HoverImage(system: .threadPlus)
                            .onTapGesture {
                                withAnimation {
                                    self.isThread = true
                                    threadSelected()
                                }
                            }
                        HoverImage(system: .smileFace)
                            .onTapGesture {
                                self.emojiPop.toggle()
                            }
                            .popover(isPresented: $emojiPop) {
                                EmojiPicker(emojiStore: EmojiStore(), selectionHandler: { _ in
                                    //                                    self.message.emoticons[$0.string] = 1
                                })
                                    .environmentObject(SharedState())
                                    .frame(width: 400, height: 300)
                            }
                    }
                }.offset(y: -10)
                    .padding(.trailing)
            }
        }
    }
}

//struct MessageView_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageView(isThread: .constant(false), selectedThreadIndex: .constant(0), selectedNoticeIndex: .constant(0), messages: .constant(mess))
//    }
//}

struct EnterExitMessageView: View {
    var message: ChatMessage
    
    var body: some View {
        HStack {
            Spacer()
            Text(message.message)
                .font(.caption)
                .padding(.all, 5)
                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.gray).opacity(0.2))
            Spacer()
        }
        
    }
}

struct DateMessageView: View {
    let date: String
    
    var body: some View {
        HStack(spacing: 20) {
            Color.gray.frame(height: 1)
            Text(date)
                .foregroundColor(.gray)
            Color.gray.frame(height: 1)
        }
    }
}

struct FileMessageView: View {
    let message: ChatMessage
    
    var body: some View {
        HStack(alignment: .top, spacing: -5) {
            KFImage(URL(string: message.sender.imageURL))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 35, height: 35)
                .clipShape(Circle())
                .onHover(perform: { hovering in
                    //                        self.profileHover = hovering
                })
            
            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    Text(message.sender.name)
                    Text(message.time.replacingOccurrences(of: "T", with: "  ").prefix(20).suffix(15))
                        .foregroundColor(.gray)
                    Spacer()
                }
                
                HStack(spacing: 20) {
                    Image(system: .clip)
                    Text(message.message)
                    Spacer()
                    Image(system: .download)
                        .onTapGesture {
                            NSSavePanel.saveFile(fileName: message.message,
                                                 fileUrl: "https://dsmhs.djsch.kr/boardCnts/fileDown.do?m=0202&s=dsmhs&fileSeq=166c48ee3999d2137c5aa9a08557aeb9",
                                                 completion: { result in
                                switch result {
                                case .success(_): break
                                case .failure(let error):
                                    print(error)
                                }
                            })
                        }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.gray).opacity(0.2))
            }.padding(.horizontal)
        }
    }
}

struct ImageMessageView: View {
    let message: ChatMessage
    
    var body: some View {
        HStack(alignment: .top) {
            KFImage(URL(string: message.sender.imageURL))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 35, height: 35)
                .clipShape(Circle())
                .onHover(perform: { hovering in
                    //                        self.profileHover = hovering
                })
            
            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    Text(message.sender.name)
                    Text(message.time.replacingOccurrences(of: "T", with: "  ").prefix(20).suffix(15))
                        .foregroundColor(.gray)
                    Spacer()
                }
                
                HStack(spacing: 10) {
                    KFImage(URL(string: message.message))
                        .resizable()
                        .frame(width: 75, height: 75)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.gray).opacity(0.2))
                .contextMenu {
                    Button {
                        NSSavePanel.saveImage(fileName: "RxSwift.png",
                                              image: NSImage(byReferencing: URL(string: message.message)!),
                                              completion: { result in
                            switch result {
                            case .success(_): break
                            case .failure(let error):
                                print(error)
                            }
                        })
                    } label: {
                        Text("저장")
                    }
                }
            }.padding(.horizontal)
        }
    }
}
