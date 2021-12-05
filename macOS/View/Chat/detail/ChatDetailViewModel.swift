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
    
    @Published var selectedNSImages: [(String, NSImage)] = []
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
        case editText(preText: String)
        
        case sendMessage
        case changeNotification(isOn: Bool)
        
        case updateChat(messageId: String)
        case deleteChat(messageId: String)
    }
    
    public struct Input {
        let onAppear = PassthroughSubject<String, Never>()
        let getChatInfo = PassthroughSubject<String, Never>()
        let setMypage = PassthroughSubject<Mypage, Never>()
        let changeNotification = PassthroughSubject<Bool, Never>()
        
        let sendImage = PassthroughSubject<(String, NSImage), Never>()
        let sendFile = PassthroughSubject<(String, Data), Never>()
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
            if !selectedNSImages.isEmpty {
                for image in selectedNSImages {
                    self.input.sendImage.send(image)
                }
            }
            if !selectedFile.isEmpty {
                for file in selectedFile {
                    self.input.sendFile.send(file)
                }
            }
            self.pushMessage()
        case .setMypage(let profile):
            self.input.setMypage.send(profile)
        case .changeNotification(let isOn):
            self.input.changeNotification.send(isOn)
        case .editText(let preText):
            self.editingText = preText
        case .updateChat(let messageId):
            self.updateMessage(messageId: messageId)
        case .deleteChat(let messageId):
            self.deleteMessage(messageId: messageId)
        }
    }
    
    init(chatRepository: ChatRepository = ChatRepositoryImpl()) {
        self.chatRepository = chatRepository
        
        self.manager.config = SocketIOClientConfiguration(arrayLiteral: .connectParams(["token": accessToken]))
        self.socket = self.manager.defaultSocket
        
        input.onAppear
            .sink(receiveValue: { _ in
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
        
        input.sendImage
            .flatMap {
                self.chatRepository.sendImageMessage(channelId: self.channelId, name: $0.0, image: $0.1)
                    .catch { _ -> Empty<Void, Never> in
                        return .init()
                    }
            }.sink(receiveValue: { _ in })
            .store(in: &bag)
        
        input.sendFile
            .flatMap {
                self.chatRepository.sendFileMessage(channelId: self.channelId, name: $0.0, file: $0.1)
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
    }
    
    private func getMessage() {
        socket.on(clientEvent: .connect) { _, _ in
            self.socket.emit("joinChannel", self.channelId)
        }
        
        self.socket.on("send") { datas, _ in // 메세지 받음
            if let datas = datas as? [[String: Any]] {
                for data in datas {
                    let newMessage = ChatMessage(dict: data)
                    self.messageList.chats.append(newMessage)
                }
            } else {
                print("----------- CASTING ERROR -------------")
                print(datas)
            }
        }
        
        self.socket.on("send-file") { datas, _ in // 파일 메세지 받음
            if let datas = datas as? [[String: Any]] {
                for data in datas {
                    let newMessage = ChatMessage(dict: data)
                    self.messageList.chats.append(newMessage)
                }
            } else {
                print("----------- CASTING ERROR2 -------------")
                print(datas)
            }
        }
        
        self.socket.on("update") { datas, _ in // 메세지가 수정됨!
            print(datas)
            
            if let datas = datas as? [[String: Any]] {
                for data in datas {
                    print(data)
                    if let editedMessage = self.messageList.chats.filter({ $0.id == data["id"] as! String }).first {
                        let index = self.messageList.chats.firstIndex(of: editedMessage)
                        self.messageList.chats[index!].message = data["message"] as! String
                    }
                }
            } else {
                print("----------- CASTING ERROR2 -------------")
                print(datas)
            }
        }
        
        self.socket.on("delete") { datas, _ in // 메세지가 삭제됨!
            if let datas = datas as? [String] {
                for data in datas {
                    if let editedMessage = self.messageList.chats.filter({ $0.id == data as! String }).first {
                        let index = self.messageList.chats.firstIndex(of: editedMessage)
                        self.messageList.chats[index!].delete = true
                    }
                }
            } else {
                print("----------- CASTING ERROR2 -------------")
                print(datas)
            }
        }
    }
    
    private func pushMessage() {
        if !self.selectedNSImages.isEmpty {
            for image in self.selectedNSImages {
                self.input.sendImage.send(image)
            }
        }
        if !self.selectedFile.isEmpty {
            for file in self.selectedFile {
                self.input.sendFile.send(file)
            }
        }
        
        if self.text.replacingOccurrences(of: " ", with: "") != "" {
            self.socket.emit("send", ["channelId": channelId, "message": text])
        }
        self.text = ""
        self.selectedNSImages = []
        self.selectedFile = []
    }
    
    private func deleteMessage(messageId: String) {
        self.socket.emit("delete", ["channelId": channelId, "messageId": messageId])
    }
    
    private func updateMessage(messageId: String) {
        self.socket.emit("update", ["channelId": channelId, "chatId": messageId, "message": editingText])
    }
}
