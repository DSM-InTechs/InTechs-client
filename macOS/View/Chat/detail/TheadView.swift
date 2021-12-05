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
    let channelId: String
    @Binding var isThread: Bool
    @Binding var message: ChatMessage
    
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
                ThreadRow(message: ThreadMessage(message: message.message, sender: message.sender, time: message.time))
                    .padding(.all, 10)
                
                HStack(spacing: 10) {
                    if message.threads.count > 0 {
                        Text("\(message.threads.count)개의 답글")
                    }
                    
                    Color.gray.opacity(0.5).frame(height: 1)
                }.padding(.horizontal)
                
                LazyVStack(spacing: 0) {
                    ForEach(message.threads, id: \.self) { message in
                        ThreadRow(message: message)
                            .environmentObject(self.viewModel)
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
                        self.viewModel.apply(.addThread(messageId: message.id))
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
    var message: ThreadMessage
    @State private var profileHover: Bool = false
    //    @State private var emojiPop = false
    
    @EnvironmentObject var viewModel: ThreadViewModel
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
                    HStack(spacing: 10) {
                        Text(message.sender.name)
                        Text(message.time.replacingOccurrences(of: "T", with: "  ").prefix(20).suffix(15))
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    
                    HStack {
                        Text(message.message)
                            .foregroundColor(.white)
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                    }
                    
                }.padding(.trailing)
            }
            
            Spacer()
        }
    }
}

//struct TheadView_Previews: PreviewProvider {
//    static var previews: some View {
//        TheadView(isThread: .constant(false), message: .constant(Message(message: "스레드", type: "TALK", isMine: true, sender: User(name: "정고은", email: "", imageURL: "", isActive: true), time: "오후 0000")))
//    }
//}
