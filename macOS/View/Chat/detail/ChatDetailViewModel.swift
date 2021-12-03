//
//  ChatDetailViewModel.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/09/03.
//

import SwiftUI
import Combine
import SocketIO

class ChatDetailViewModel: ObservableObject {
    @Published var text: String = ""
    @Published var editingText: String = ""
    
    @Published var selectedNSImages: [NSImage] = []
    @Published var selectedFile: [(String, Data)] = []
    
    @Published var channel = RoomInfo(id: "", name: "", image: "", users: [RoomUser](), notification: false, dm: false)
    @Published var messageList = MessageList(channelId: "", chats: [ChatMessage]())
    @Published var profile: Mypage = Mypage(name: "", email: "", image: "")
    
    @UserDefault(key: "userEmail", defaultValue: "")
    public var userEmail: String
    
    @UserDefault(key: "accessToken", defaultValue: "")
    private var accessToken: String
    
    private var manager = SocketManager(socketURL: URL(string: "http://localhost:8010")!, config: [.log(true), .compress])
    private var socket: SocketIOClient!
    private var channelId = ""
    
    private let chatRepository: ChatRepository
    
    private var bag = Set<AnyCancellable>()
    
    public enum Event {
        case onAppear(channelId: String)
        case getChatInfo
        case setMypage(profile: Mypage)
        case sendMessage
        case changeNotification(isOn: Bool)
    }
    
    public struct Input {
        let onAppear = PassthroughSubject<String, Never>()
        let getChatInfo = PassthroughSubject<String, Never>()
        let setMypage = PassthroughSubject<Mypage, Never>()
        let changeNotification = PassthroughSubject<Bool, Never>()
    }
    
    public let input = Input()
    
    public func apply(_ input: Event) {
        switch input {
        case .onAppear(let channelId):
            self.channelId = channelId
            self.input.onAppear.send(channelId)
            self.input.getChatInfo.send(channelId)
        case .getChatInfo:
            self.input.getChatInfo.send(self.channelId)
        case .sendMessage:
            self.pushMessage()
        case .setMypage(let profile):
            self.input.setMypage.send(profile)
        case .changeNotification(let isOn):
            self.input.changeNotification.send(isOn)
        }
    }
    
    init(chatRepository: ChatRepository = ChatRepositoryImpl()) {
        self.chatRepository = chatRepository
        
        self.manager.config = SocketIOClientConfiguration(
            arrayLiteral: .connectParams(["token": accessToken]))
        
        input.onAppear
            .sink(receiveValue: { _ in
                print(self.channelId)
                self.socket = self.manager.defaultSocket
                self.joinChannel()
                
                self.getMessage()
            }).store(in: &bag)
        
        input.getChatInfo
            .flatMap {
                self.chatRepository.getChatInfo(channelId: $0)
                    .catch { _ -> Empty<RoomInfo, Never> in
                        return .init()
                    }
            }
            .assign(to: \.channel, on: self)
            .store(in: &bag)
        
        input.onAppear
            .flatMap {
                self.chatRepository.getMessagelist(channelId: $0, page: 0)
                    .catch { _ -> Empty<MessageList, Never> in
                        return .init()
                    }
            }
            .assign(to: \.messageList, on: self)
            .store(in: &bag)
        
        input.setMypage
            .assign(to: \.profile, on: self)
            .store(in: &bag)
        
        input.changeNotification
            .flatMap { _ in
                self.chatRepository.updateNotification(channelId: self.channelId)
                    .catch { _ -> Empty<Void, Never> in
                        return .init()
                    }
            }.sink(receiveValue: { _ in })
            .store(in: &bag)
    }
    
    deinit {
        socket.disconnect()
    }
    
    private func joinChannel() {
        socket.connect()
        
        self.socket.emit("joinChannel", channelId)
    }
    
    private func getMessage() {
        socket.on(clientEvent: .connect) { _, _ in
               print("socket connected")
           }
        
        self.socket.on(self.channelId) { dataArray, _ in
            //            var newMessage = ChatMessage(message: self.text, sender: MessageSender(name: "", email: "", imageURL: ""))
            
            print(type(of: dataArray))
            print(dataArray)
            
            //            {sender: "userName", message: "message", isMine: true, time: 2021-10-28T02:59:17.652+00:00}
            
            //            let data = dataArray[0] as! NSDictionary
            //            chat.type = data["type"] as! Int
            //            chat.message = data["message"] as! String
            //
            //            print(chat)
            //
            //            self.messageList.append(newMessage)
            
            //            self.updateChat(count: self.myChat.count) {
            //                print("Get Message")
            //            }
        }
    }
    
    private func pushMessage() {
        if self.text.replacingOccurrences(of: " ", with: "") != "" {
//            self.socket.emit("send", with: ["channelId": channelId, "message": self.text])
            self.socket.emit("send", MessageRequest(channelId: channelId, message: text))
//            self.socket.emit(self.channelId, self.text)
            self.messageList.chats.append(ChatMessage(id: "", message: self.text, time: "", sender: MessageSender(name: profile.name, email: profile.email, imageURL: profile.image), chatType: MessageType.talk.rawValue, delete: false))
        }
        self.text = ""
        self.selectedNSImages = []
        self.selectedFile = []
    }
}
