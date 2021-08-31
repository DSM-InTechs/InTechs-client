//
//  AllChatView.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/08/22.
//

import SwiftUI

struct ChatListView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    @ObservedObject var chatVM = ChatViewModel()
    
    @Namespace private var animation
    
    @State private var mentionsPop = false
    @State private var editPop = false
    
    var body: some View {
        ZStack {
            VStack {
                // Title
                HStack(spacing: 15) {
                    Text("채팅")
                        .font(.title)
                    
                    Spacer()
                    
                    Button(action: {
                        self.mentionsPop.toggle()
                    }, label: {
                        Image(system: .mention)
                            .foregroundColor(.white)
                    }).frame(width: 25, height: 25)
                    .popover(isPresented: $mentionsPop) {
                        MentionsPopView()
                            .frame(width: 200)
                    }
                    
                    Button(action: {
                        self.editPop.toggle()
                    }, label: {
                        Image(system: .edit)
                            .foregroundColor(.white)
                    }).frame(width: 25, height: 25)
                    .popover(isPresented: $editPop) {
                        EditPopView()
                            .frame(width: 200)
                    }
                }.padding()
                
                // Tab
                VStack(spacing: 5) {
                    HStack(spacing: 0) {
                        ChatTabButton(animation: animation, tab: .Home, selectedTab: $chatVM.selectedTab)
                            .onTapGesture {
                                withAnimation {
                                    chatVM.selectedTab = .Home
                                }
                            }
                        
                        ChatTabButton(animation: animation, tab: .Channels, selectedTab: $chatVM.selectedTab)
                            .onTapGesture {
                                withAnimation {
                                    chatVM.selectedTab = .Channels
                                }
                            }
                        
                        ChatTabButton(animation: animation, tab: .DMs, selectedTab: $chatVM.selectedTab)
                            .onTapGesture {
                                withAnimation {
                                    chatVM.selectedTab = .DMs
                                }
                            }
                        
                        Spacer()
                    }
                    Divider()
                }
                
                List(selection: $homeVM.selectedRecentMsg) {
                    ForEach(homeVM.msgs) { message in
                        NavigationLink(destination: ChatDetailView(user: message)) {
                            ChatRow(recentMsg: message)
                        }
                    }
                }
            }
            
            HStack {
                Color.black.frame(width: 1)
                Spacer()
            }
        }
        .ignoresSafeArea(.all, edges: .all)
    }
}

struct ChatRow: View {
    var recentMsg: RecentMessage
    
    var body: some View {
        HStack {
            Image(recentMsg.userImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            
            VStack(spacing: 4) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(recentMsg.userName)
                            .fontWeight(.bold)
                        
                        Text(recentMsg.lastMsg)
                            .font(.caption)
                    }
                    
                    Spacer(minLength: 10)
                    
                    VStack {
                        Text(recentMsg.lastMsgTime)
                            .font(.caption)
                        
                        if recentMsg.pendingMsgs != "0" {
                            Text(recentMsg.pendingMsgs)
                                .font(.caption2)
                                .padding(5)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                        } else {
                            Spacer()
                        }
                    }
                }
            }
        }
    }
}


struct AllChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatListView()
    }
}

struct MentionsPopView: View {
    var body: some View {
        Text("No Mentions")
            .padding([.top, .bottom], 20)
    }
}

struct EditPopView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading, spacing: 15) {
                Text("Read")
                    .foregroundColor(.gray)
                
                Button(action: {}, label: {
                    HStack {
                        Image(system: .checklist)
                        Text("전부 읽음처리")
                    }
                }).buttonStyle(PlainButtonStyle())
            }
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Browse")
                    .foregroundColor(.gray)
                    .padding(.top, 10)
                
                Button(action: {}, label: {
                    HStack {
                        Image(system: .person)
                        Text("DM 시작하기")
                    }
                }).buttonStyle(PlainButtonStyle())
            }
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Create")
                    .foregroundColor(.gray)
                    .padding(.top, 10)
                
                Button(action: {}, label: {
                    HStack {
                        Text("#")
                        Text("새 채널")
                    }
                }).buttonStyle(PlainButtonStyle())
            }
        }.padding([.top, .bottom], 10)
        .padding(.bottom, 10)
    }
}
