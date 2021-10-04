//
//  TheadView.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/09/03.
//

import SwiftUI
import GEmojiPicker

struct TheadView: View {
    @Binding var isThread: Bool
    @State private var emojiPop = false
    @State private var filePop = false
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .center, spacing: 10) {
                HStack {
                    Text("스레드")
                    Spacer()
                    Button(action: {
                        withAnimation {
                            self.isThread = false
                        }
                    }, label: {
                        Image(system: .xmark)
                    })
                }
                
            }.padding()
            
            Divider()
            
            VStack(spacing: 5) {
                ThreadRow(message: Message(id: "", message: "스레드시작", myMessage: false), user: RecentMessage(lastMsg: "마지막 메세지", lastMsgTime: "15:00", pendingMsgs: "0", userName: "유저", userImage: "placeholder", allMsgs: eachmsg.shuffled()))
                    .padding(.all, 10)
                
                HStack(spacing: 10) {
                    Text("1개의 답글")
                    Color.gray.opacity(0.5).frame(height: 1)
                }.padding(.horizontal)
            }
           
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(0...3, id: \.self) { _ in
                        ThreadRow(message: Message(id: "", message: "댓글입니당", myMessage: false), user: RecentMessage(lastMsg: "마지막 메세지", lastMsgTime: "15:00", pendingMsgs: "0", userName: "유저", userImage: "placeholder", allMsgs: eachmsg.shuffled()))
                            .padding(.all, 10)
                    }
                }
                
                HStack {
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
                    
                    TextField("Enter Message", text: .constant(""), onCommit: {
//                        homeVM.sendMessage(user: user)
                    })
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.white))
                    
                    Button(action: {
                        self.emojiPop.toggle()
                    }, label: {
                        Image(system: .smileFace)
                            .font(.title2)
                    }).buttonStyle(PlainButtonStyle())
                    .popover(isPresented: $emojiPop) {
                        EmojiPicker(emojiStore: EmojiStore(), selectionHandler: { _ in })
                            .environmentObject(SharedState())
                            .frame(width: 400, height: 300)
                    }
                }.padding(.horizontal)
                .padding(.top, 10)
            }
            Spacer()
        }
    }
}

struct ThreadRow: View {
    var message: Message
    var user: RecentMessage
    @State private var hover: Bool = false
    @State private var isEditing: Bool = false
    @State private var profileHover: Bool = false
    @State private var emojiPop = false
    
    @EnvironmentObject var homeVM: HomeViewModel
    
    var body: some View {
        ZStack {
            HStack(alignment: .top, spacing: 10) {
                VStack {
                    Image(user.userImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 35, height: 35)
                        .clipShape(Circle())
                        .onHover(perform: { hovering in
                            self.profileHover = hovering
                        })
                    
                }
                
                VStack(alignment: .leading, spacing: 3) {
                    HStack {
                        Text(user.userName)
                        Spacer()
                        Text("10: 10")
                    }
                    
                    if isEditing {
                        VStack(spacing: 10) {
                            HStack {
                                Image(system: .clip)
                                
                                TextField("", text: $homeVM.message, onCommit: {
                                    homeVM.sendMessage(user: user)
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
                                        self.isEditing = false
                                    }
                                Spacer()
                                Text("확인")
                                    .padding(.all, 5)
                                    .padding(.horizontal, 10)
                                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.blue))
                                    .onTapGesture {
                                        self.isEditing = false
                                    }
                            }
                            .padding(.bottom)
                        }
                    } else {
                        HStack {
                            Text(message.message)
                                .foregroundColor(.white)
                            Spacer()
                        }
                    }
                }.padding(.trailing)
                .onHover(perform: { hovering in
                    self.hover = hovering
                    if isEditing {
                        self.hover = false
                    }
                })
            }
            
            Spacer()
            if self.hover {
                HStack {
                    Spacer(minLength: 0)
                    HStack(spacing: 0) {
                        HoverImage(system: .trash)
                            .onTapGesture {
                                self.homeVM.toast = .messageDelete
                            }
                        HoverImage(system: .pencil)
                            .onTapGesture {
                                self.isEditing = true
                            }
                        HoverImage(system: .pin)
                        HoverImage(system: .smileFace)
                            .onTapGesture {
                                self.emojiPop.toggle()
                            }
                            .popover(isPresented: $emojiPop) {
                                EmojiPicker(emojiStore: EmojiStore(), selectionHandler: { _ in })
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

struct TheadView_Previews: PreviewProvider {
    static var previews: some View {
        TheadView(isThread: .constant(false))
    }
}