//
//  ChatDetailViewe.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/08/26.
//

import SwiftUI
import Introspect
import GEmojiPicker
import Kingfisher

struct ChatDetailView: View {
    @ObservedObject var viewModel = ChatDetailViewModel()
    @Binding var channel: Channel
    
    @State var uiTabarController: UITabBarController?
    @State private var showInfoView = false
    @State private var showThread = false
    @State private var fileSheet = false
    @State private var isFile = false
    @State private var isImage = false
    @State private var isSearch = false
    @State private var isEditing = false
    @State private var document: InputDoument = InputDoument(input: "")
    
    @State private var isEmoji = false
    @State private var isMessageDelete = false
    
    let title: String
    
    var body: some View {
        ZStack {
            ScrollView {
                LazyVStack {
                    ForEach(channel.allMsgs, id: \.id) { message in
                        if message.type == MessageType.talk.rawValue {
                            MessageRow(message: message)
                                .padding(.all, 10)
                                .contextMenu {
                                    Button(action: {
                                        viewModel.text = "asdf"
                                        self.isEditing = true
                                    }, label: {
                                        HStack {
                                            Text("수정")
                                            Spacer()
                                            Image(system: .edit)
                                        }
                                    })
                                    
                                    Button(action: {
                                        self.isMessageDelete.toggle()
                                    }, label: {
                                        HStack {
                                            Text("삭제")
                                            Spacer()
                                            Image(system: .trash)
                                        }
                                    }).foregroundColor(.red)
                                    
                                    Button(action: {
                                        
                                    }, label: {
                                        HStack {
                                            Text("고정")
                                            Spacer()
                                            Image(system: .pin)
                                        }
                                    })
                                    
                                    Button(action: {
                                        self.showThread.toggle()
                                    }, label: {
                                        HStack {
                                            Text("스레드 만들기")
                                            Spacer()
                                            Image(system: .threadPlus)
                                        }
                                    })
                                    
                                    Button(action: {
                                        self.isEmoji.toggle()
                                    }, label: {
                                        HStack {
                                            Text("반응 달기")
                                            Spacer()
                                            Image(system: .smileFace)
                                        }
                                    })
                                }
                        } else if message.type == MessageType.image.rawValue {
                            ImageMessageRow(message: message)
                        } else if message.type == MessageType.file.rawValue {
                            FileMessageRow(message: message)
                        }
                    }
                }
            }
            .alert(isPresented: $isMessageDelete, content: {
                Alert(title: Text("확인"), message: Text("(메세지)를 삭제하시겠습니까?"), primaryButton: .destructive(Text("삭제"), action: {
                    // Some action
                }), secondaryButton: .cancel())
            })
            
            EmojiPicker(isOpen: $isEmoji, selectionHandler: { _ in })
            
            NavigationLink(destination: ChannelInfoView(),
                           isActive: self.$showInfoView) { EmptyView() }
                           .hidden()
            
            NavigationLink(destination: ThreadView(),
                           isActive: self.$showThread) { EmptyView() }
                           .hidden()
            
            //            if isSearch {
            //                VStack {
            //                    SearchBar(text: .constant(""))
            //                    ScrollView {
            //                        LazyVStack {
            //                            ForEach(0...10, id: \.self) { message in
            //                                // 스레드 있으면 스레드뷰 이동
            //                                ChatDetailRow(message: message)
            //                                    .padding(.all, 10)
            //
            //                            }
            //                        }
            //                    }
            //                }.background(Color(Asset.white))
            //            }
            
            VStack(spacing: 20) {
                Spacer()
                
                VStack {
                    Divider()
                        .frame(width: UIFrame.width)
                    
                    VStack {
                        Group {
                            if isEditing {
                                VStack(alignment: .leading, spacing: 0) {
                                    HStack {
                                        Image(system: .xmark)
                                            .onTapGesture {
                                                self.isEditing.toggle()
                                            }
                                        
                                        Color.gray.frame(width: 2)
                                        
                                        VStack {
                                            Text("메세지 수정")
                                                .font(.callout)
                                            Text("원래 메세지")
                                                .foregroundColor(.gray)
                                                .font(.caption)
                                        }
                                        Spacer()
                                    }.padding(.all, 10)
                                        .background(Color.gray.opacity(0.5))
                                        .frame(height: UIFrame.height / 14)
                                    
                                    HStack {
                                        Image(system: .clip)
                                            .onTapGesture {
                                                self.fileSheet = true
                                            }
                                        TextField("메세지를 입력하세요", text: $viewModel.text)
                                        //                            Text(document.input)
                                        Image(system: .checkmarkCircleFill)
                                            .onTapGesture {
                                                self.isEditing.toggle()
                                            }
                                    }.padding(.bottom, 10)
                                        .frame(height: UIFrame.height / 12)
                                }
                                .padding(.horizontal)
                                
                            } else {
                                HStack {
                                    Image(system: .clip)
                                        .onTapGesture {
                                            self.fileSheet = true
                                        }
                                    TextField("메세지를 입력하세요", text: $viewModel.text)
                                    if viewModel.text == "" {
                                        Image(system: .paperplane)
                                    } else {
                                        Image(system: .paperplaneFill)
                                            .onTapGesture {
                                                if viewModel.text != "" {
                                                    self.channel.allMsgs.append(Message(message: viewModel.text, type: "TALK", isMine: true, sender: user1, time: "오후 11:15"))
                                                }
                                            }
                                    }
                                }.padding(.bottom, 10)
                                    .padding(.horizontal)
                                    .frame(height: UIFrame.height / 12)
                            }
                        }
                        .actionSheet(isPresented: $fileSheet) {
                            ActionSheet(title: Text("사진 또는 파일을 첨부하세요"), buttons: [.default(Text("Photo")) {
                                self.isImage = true
                            }, .default(Text("File")) {
                                self.isFile = true
                            }, .cancel(Text("Cancel"))])
                        }
                        .sheet(isPresented: $isImage) {
                            ImagePicker(sourceType: .photoLibrary, imagePicked: { _ in
                                
                            })
                        }
                        .fileImporter(
                            isPresented: $isFile,
                            allowedContentTypes: [.plainText],
                            allowsMultipleSelection: false
                        ) { result in
                            do {
                                guard let selectedFile: URL = try result.get().first else { return }
                                if selectedFile.startAccessingSecurityScopedResource() {
                                    guard let input = String(data: try Data(contentsOf: selectedFile), encoding: .utf8) else { return }
                                    defer { selectedFile.stopAccessingSecurityScopedResource() }
                                    document.input = input
                                } else {
                                    // Handle denied access
                                }
                            } catch {
                                // Handle failure.
                                print("Unable to read file contents")
                                print(error.localizedDescription)
                            }
                        }
                        
                    }.frame(width: UIFrame.width)
                }.background(Color(Asset.white))
                
            }.ignoresSafeArea()
            
                .navigationBarTitle(title)
                .navigationBarItems(trailing: HStack(spacing: 15) {
                    SystemImage(system: .search)
                        .frame(width: 20, height: 20)
                        .foregroundColor(.blue)
                        .onTapGesture {
                            withAnimation {
                                self.isSearch = true
                            }
                        }
                    
                    SystemImage(system: .info)
                        .frame(width: 20, height: 20)
                        .foregroundColor(.blue)
                        .onTapGesture {
                            self.showInfoView.toggle()
                        }
                })
                .introspectTabBarController { (UITabBarController) in
                    UITabBarController.tabBar.isHidden = true
                    uiTabarController = UITabBarController
                }
        }
    }
}

struct MessageRow: View {
    let message: Message
    
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 10) {
                KFImage(URL(string: message.sender.imageURL))
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 40, height: 40)
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(message.sender.name)
                            .fontWeight(.bold)
                        Spacer()
                        Text(message.time)
                            .foregroundColor(.gray)
                    }
                    
                    Text(message.message)
                }
            }
        }.background(Color(Asset.white))
    }
}

struct FileMessageRow: View {
    let message: Message
    
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 10) {
                KFImage(URL(string: message.sender.imageURL))
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 40, height: 40)
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(message.sender.name)
                            .fontWeight(.bold)
                        Spacer()
                        Text(message.time)
                            .foregroundColor(.gray)
                    }
                    
                    HStack(spacing: 20) {
                        Image(system: .clip)
                        Text(message.message)
                        Spacer()
                        Image(system: .download)
                    }.padding()
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.gray).opacity(0.2))
                }
            }
        }.padding(.all, 10)
        .background(Color(Asset.white))
    }
}

struct ImageMessageRow: View {
    let message: Message
    
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 10) {
                KFImage(URL(string: message.sender.imageURL))
                    .resizable()
                    .frame(width: 40, height: 40)
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(message.sender.name)
                            .fontWeight(.bold)
                        Spacer()
                        Text(message.time)
                            .foregroundColor(.gray)
                    }
                    
                    KFImage(URL(string: message.message))
                }
            }
        }.background(Color(Asset.white))
    }
}

struct ChatDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ChatListView()
        ChatDetailView(channel: .constant(Channel(lastMsg: "", lastMsgTime: "", pendingMsgs: "", name: "", imageUrl: "", allMsgs: [Message]())), title: "채널 이름")
    }
}
