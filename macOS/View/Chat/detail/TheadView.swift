//
//  TheadView.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/09/03.
//

import SwiftUI
import GEmojiPicker
import Kingfisher

struct TheadView: View {
    @Binding var isThread: Bool
    @Binding var message: Message
    
    @ObservedObject var viewModel = ThreadViewModel()
    
    @State var selectedNSImages: [(String, NSImage)] = []
    @State var selectedFile: [(String, Data)] = []
    
    @State private var emojiPop = false
    @State private var filePop = false
    
    var body: some View {
        VStack(spacing: 0) {
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
            }.padding()
            
            Divider()
            
            ScrollView {
                ThreadRow(message: message)
                    .padding(.all, 10)
                
                HStack(spacing: 10) {
                    if message.threadMessages.count > 0 {
                        Text("\(message.threadMessages.count)개의 답글")
                    }
                    
                    Color.gray.opacity(0.5).frame(height: 1)
                }.padding(.horizontal)
                
                LazyVStack(spacing: 0) {
                    ForEach(message.threadMessages, id: \.id) { message in
                        ThreadRow(message: message)
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
                            FileTypeSelectView(selectedImage: $selectedNSImages, selectedFile: $selectedFile)
                                .padding()
                        }
                    
                    LazyHStack {
                        ForEach(0..<selectedNSImages.count, id: \.self) { index in
                            Image(nsImage: selectedNSImages[index].1)
                                .resizable()
                                .frame(width: 100, height: 100)
                        }
                    }
                    
                    TextField("메세지를 입력하세요", text: $viewModel.text, onCommit: {
                        self.message.threadMessages.append(Message(message: viewModel.text, type: "TALK", isMine: true, sender: user1, time: "오후 11:11"))
                        self.message.isThread = true
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
        }
    }
}

struct ThreadRow: View {
    var message: Message
    @State private var hover: Bool = false
    @State private var isEditing: Bool = false
    @State private var profileHover: Bool = false
    @State private var emojiPop = false
    
    @ObservedObject var viewModel = ThreadViewModel()
    @EnvironmentObject var homeVM: HomeViewModel
    
    var body: some View {
        ZStack {
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
                    HStack {
                        Text(message.sender.name)
                        Spacer()
                        Text(message.time)
                    }
                    
                    if isEditing {
                        VStack(spacing: 10) {
                            HStack {
                                Image(system: .clip)
                                
                                TextField("", text: $viewModel.text, onCommit: {
                                    //                                        self.messages.append(Message(message: homeVM.message, isMine: true, sender: User(name: "정고은", email: "gogo8272@gmail.com", imageURL: "", isActive: true), time: "오후 10:10"))
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
                                .fixedSize(horizontal: false, vertical: true)
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
                                //                            self.homeVM.toast = .messageDelete(execute: {
                                //                                self.message.message = "이 메세지는 삭제되었습니다."
                                //                            })
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
        TheadView(isThread: .constant(false), message: .constant(Message(message: "스레드", type: "TALK", isMine: true, sender: User(name: "정고은", email: "", imageURL: "", isActive: true), time: "오후 0000")))
    }
}
