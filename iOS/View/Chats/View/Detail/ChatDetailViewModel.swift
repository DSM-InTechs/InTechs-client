//
//  ChatDetailViewModel.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/30.
//

import SwiftUI
import Combine

class ChatDetailViewModel: ObservableObject {
    @Published var text: String = ""
    @Published var editingText: String = ""
    @Published var selectedImage: [(String, UIImage)] = []
    @Published var selectedFile: [(String, Data)] = []
    
    @Published var channel = RoomInfo(id: "", name: "", image: "", users: [RoomUser](), notification: false, dm: false)
    @Published var messageList = MessageList(channelId: "", chats: [ChatMessage]())
    @Published var profile: Mypage = Mypage(name: "", email: "", image: "")
    
    private let chatRepository: ChatRepository
    private let mypageRepository: MypageRepository
    private let socketManager = SocketIOManager.shared
    private var channelId = ""
    
    private var bag = Set<AnyCancellable>()
    
    public enum Event {
        case onAppear(channelId: String)
        case sendMessage
        
        case updateChat(messageId: String)
        case deleteChat(messageId: String)
    }
    
    public struct Input {
        let onAppear = PassthroughSubject<String, Never>()
        let getChatInfo = PassthroughSubject<Void, Never>()
        
        let sendImage = PassthroughSubject<(String, UIImage), Never>()
        let sendFile = PassthroughSubject<(String, Data), Never>()
    }
    
    public let input = Input()
    
    public func apply(_ input: Event) {
        switch input {
        case .onAppear(let channelId):
            self.channelId = channelId
            self.input.onAppear.send(self.channelId)
            self.input.getChatInfo.send(())
            
        case .sendMessage:
            self.pushMessage()
            
        case .updateChat(let messageId):
            self.updateMessage(messageId: messageId)
        case .deleteChat(let messageId):
            self.deleteMessage(messageId: messageId)
        }
    }
    
    init(chatRepository: ChatRepository = ChatRepositoryImpl(),
         mypageRepository: MypageRepository = MypageRepositoryImpl()) {
        self.chatRepository = chatRepository
        self.mypageRepository = mypageRepository
        
        input.onAppear
            .sink(receiveValue: {
                self.socketManager.connectChannel(channelId: $0)
                self.getMessage()
            }).store(in: &bag)
        
        input.onAppear
            .flatMap { _ in
                self.mypageRepository.mypage()
                    .catch { _ -> Empty<Mypage, Never> in
                        return .init()
                    }
            }.assign(to: \.profile, on: self)
            .store(in: &bag)
        
        input.onAppear
            .flatMap {
                self.chatRepository.getMessagelist(channelId: $0, page: 0)
                    .catch { _ -> Empty<MessageList, Never> in
                        return .init()
                    }
            }.assign(to: \.messageList, on: self)
            .store(in: &bag)
        
        input.getChatInfo
            .flatMap {
                self.chatRepository.getChatInfo(channelId: self.channelId)
                    .catch { _ -> Empty<RoomInfo, Never> in
                        return .init()
                    }
            }.assign(to: \.channel, on: self)
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
    
    private func getErrorMessage(error: NetworkError) -> String {
        switch error {
        case .notFound:
            return "유저를 찾을 수 없습니다."
        case .unauthorized:
            return "토큰이 만료되었습니다."
        default:
            return error.message
        }
    }
    
    private func getMessage() {
        self.socketManager.on(.getMessage, callback: { datas, _ in
            if let datas = datas as? [[String: Any]] {
                for data in datas {
                    let newMessage = ChatMessage(dict: data)
                    self.messageList.chats.append(newMessage)
                }
            } else {
                print("----------- CASTING ERROR -------------")
                print(datas)
            }
        })
        
        self.socketManager.on(.getFileMessage, callback: { datas, _ in
            if let datas = datas as? [[String: Any]] {
                for data in datas {
                    let newMessage = ChatMessage(dict: data)
                    self.messageList.chats.append(newMessage)
                }
            } else {
                print("----------- CASTING ERROR -------------")
                print(datas)
            }
        })
        
        self.socketManager.on(.getUpdatedMessage, callback: { datas, _ in
            if let datas = datas as? [[String: Any]] {
                for data in datas {
                    if let editedMessage = self.messageList.chats.filter({ $0.id == data["id"] as! String }).first {
                        let index = self.messageList.chats.firstIndex(of: editedMessage)
                        self.messageList.chats[index!].message = data["message"] as! String
                    }
                }
            } else {
                print("----------- CASTING ERROR2 -------------")
                print(datas)
            }
        })
        
        self.socketManager.on(.getDeletedMessage, callback: { datas, _ in
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
        })
        
        self.socketManager.on(.getThreadMessage, callback: { datas, _ in
            if let datas = datas as? [[String: Any]] {
                for data in datas {
                    if let originalMessage = self.messageList.chats.filter({ $0.id == data["chatId"] as! String }).first {
                        print(originalMessage)
                        let index = self.messageList.chats.firstIndex(of: originalMessage)
                        let newMessage = ThreadMessage(dict: data)
                        self.messageList.chats[index!].threads.append(newMessage)
                    }
                }
            } else {
                print("----------- CASTING ERROR2 -------------")
                print(datas)
            }
        })
    }
    
    private func pushMessage() {
        if !self.selectedImage.isEmpty {
            for image in self.selectedImage {
                self.input.sendImage.send(image)
            }
        }
        if !self.selectedFile.isEmpty {
            for file in self.selectedFile {
                self.input.sendFile.send(file)
            }
        }
        
        if self.text.replacingOccurrences(of: " ", with: "") != "" {
            self.socketManager.emit(.sendMessage(channelId: self.channelId, message: self.text))
        }
        self.text = ""
        self.selectedImage = []
        self.selectedFile = []
    }
    
    private func deleteMessage(messageId: String) {
        self.socketManager.emit(.deleteMessage(channelId: self.channelId, messageId: messageId))
    }
    
    private func updateMessage(messageId: String) {
        self.socketManager.emit(.updateMessage(channelId: self.channelId, messageId: messageId, newMessage: self.editingText))
    }
}
