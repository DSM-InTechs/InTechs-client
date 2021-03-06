//
//  ChatDetailView.swift
//  InTechs Extension
//
//  Created by GoEun Jeong on 2021/09/01.
//

import SwiftUI
//import Kingfisher

struct ChatDetailView: View {
    let channel: ChatRoom
    let messageList = MessageList(channelId: "", notice: nil, chats: [ChatMessage]())
    
    var body: some View {
        List {
            ForEach(messageList.chats, id: \.self) { message in
                // 스레드 있으면 스레드뷰 이동
                ChatDetailRow(message: message)
                    .padding(.all, 10)
                
            }
        }.listStyle(CarouselListStyle())
            .navigationTitle(channel.name)
    }
}

struct ChatDetailRow: View {
    let message: ChatMessage
    
    var body: some View {
        ZStack {
            if message.chatType == MessageType.talk.rawValue {
                VStack {
                    HStack(spacing: 5) {
                        VStack(alignment: .leading) {
                            HStack {
                                //                        KFImage(URL(string: message.sneder.imageURL))
                                //                            .resizable()
                                //                            .frame(width: 20, height: 20)
                                Text(message.sender.name)
                                    .fontWeight(.bold)
                                    .lineLimit(1)
                                Spacer(minLength: 0)
                                Text(message.time)
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }
                            
                            Text(message.message)
                                .font(.caption2)
                        }
                    }
                }
            } else if message.chatType == MessageType.info.rawValue {
                EnterExitMessageView(name: message.sender.name)
            } else if message.chatType == MessageType.file.rawValue {
                FileMessageView(message: message)
            }
        }
    }
}

//struct ChatDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatDetailView(channel: Channel(lastMsg: "", lastMsgTime: "", pendingMsgs: "", name: "", imageUrl: "", allMsgs: [Message]()))
//    }
//}

struct EnterExitMessageView: View {
    let isEnter: Bool = true
    let name: String
    
    var body: some View {
        Group {
            if isEnter {
                Text("\(name)님이 입장하셨습니다.")
                    .font(.caption2)
                    .padding(.all, 5)
                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.gray).opacity(0.2))
            } else {
                Text("\(name)님이 퇴장하셨습니다.")
                    .font(.caption2)
                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.gray).opacity(0.2))
            }
        }
    }
}

struct FileMessageView: View {
    let message: ChatMessage
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                //                        KFImage(URL(string: message.sneder.imageURL))
                //                            .resizable()
                //                            .frame(width: 20, height: 20)
                Text(message.sender.name)
                    .fontWeight(.bold)
                    .lineLimit(1)
                Spacer(minLength: 0)
                Text(message.time)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            
            Text(message.message)
                .font(.caption)
                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.gray).opacity(0.2))
        }
    }
}

