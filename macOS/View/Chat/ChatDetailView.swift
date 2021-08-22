//
//  DetailView.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/08/22.
//

import SwiftUI
import GEmojiPicker

struct ChatDetailView: View {
    @EnvironmentObject var homeData: HomeViewModel
    var user: RecentMessage
    @State private var emoji = false
    @State private var file = false
    
    var body: some View {
        GeometryReader { geo in
            HStack {
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
                        
                        Button(action: {}, label: {
                            Image(system: .dot)
                                .font(.title2)
                        })
                        .buttonStyle(PlainButtonStyle())
                        
                        Button(action: {}, label: {
                            Image(system: .search)
                                .font(.title2)
                        })
                        .buttonStyle(PlainButtonStyle())
                        
                        Button(action: {}, label: {
                            Image(system: .info)
                                .font(.title2)
                        })
                        .buttonStyle(PlainButtonStyle())
                        
                        HStack(spacing: 5) {
                            Button(action: {}, label: {
                                Image(system: .bell)
                                    .font(.title2)
                            })
                            .buttonStyle(PlainButtonStyle())
                            .frame(width: 10, height: 10)
                            
                            Button(action: {}, label: {
                                Image(system: .filledDownArrow).font(.title2)
                            })
                            .buttonStyle(PlainButtonStyle())
                            .frame(width: 10, height: 10)
                        }.padding(.all, 10)
                        .contentShape(RoundedRectangle(cornerRadius: 10))
                        .background(Color.green.opacity(0.2))
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    Divider()
                    
                    MessageView(user: user)
                    
                    HStack(spacing: 15) {
                        Button(action: {
                            self.file.toggle()
                        }, label: {
                            Image(system: .clip)
                                .font(.title2)
                        }).buttonStyle(PlainButtonStyle())
                        .popover(isPresented: $file) {
                            FileTypeSelectView()
                                .padding()
                        }
                        
                        TextField("Enter Message", text: $homeData.message, onCommit: {
                            homeData.sendMessage(user: user)
                        })
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.vertical, 8)
                        .padding(.horizontal)
                        .clipShape(Capsule())
                        .background(Capsule().strokeBorder(Color.white))
                        
                        Button(action: {
                            self.emoji.toggle()
                        }, label: {
                            Image(system: .smileFace)
                                .font(.title2)
                        }).buttonStyle(PlainButtonStyle())
                        .popover(isPresented: $emoji) {
                            EmojiPicker(emojiStore: EmojiStore(), selectionHandler: { _ in })
                                .environmentObject(SharedState())
                                .frame(width: geo.size.width / 2.2, height: geo.size.height / 2.5)
                        }
                        
                    }
                    .padding([.horizontal, .bottom])
                }
                
            }
            .padding(.trailing, 70)
        }
        .ignoresSafeArea(.all, edges: .all)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        Home()
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
            Button(action: {}, label: {
                HStack {
                    Image(systemName: "doc.text")
                    Text("File")
                    Spacer()
                }.font(.title3)
            }).buttonStyle(PlainButtonStyle())
            
            Button(action: {
                let dialog = NSOpenPanel()
                
                dialog.showsResizeIndicator    = true
                dialog.showsHiddenFiles        = false
                dialog.allowsMultipleSelection = false
                dialog.canChooseDirectories = false
                dialog.allowedFileTypes        = ["png", "jpg", "jpeg"]
                
                if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
                    let result = dialog.url
                    
                    if (result != nil) {
                        //                        let path: String = result!.path
                        
                        // path contains the directory path e.g
                        // /Users/ourcodeworld/Desktop/folder
                    }
                } else {
                    // User clicked on "Cancel"
                    return
                }
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
