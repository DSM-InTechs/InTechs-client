//
//  ChannelInfoViewModel.swift
//  InTechs
//
//  Created by GoEun Jeong on 2021/12/03.
//

import SwiftUI
import Combine

class ChannelInfoViewModel: ObservableObject {
    @Published var selectedTab: ChannelInfoTab = .subscribers
    @Published var userEmail = ""
    
    @Published var channel = RoomInfo(id: "", name: "", image: "", users: [RoomUser](), notification: false, dm: false)
    @Published var notices = [ChatNotice]()
    @Published var files = [ChatMessage]()
    
    private let chatRepository: ChatRepository
    
    private var bag = Set<AnyCancellable>()
    
    public enum Event {
        case onAppear(channelId: String)
        case addUser
    }
    
    public struct Input {
        let onAppear = PassthroughSubject<String, Never>()
        let addUser = PassthroughSubject<String, Never>()
    }
    
    public let input = Input()
    
    public func apply(_ input: Event) {
        switch input {
        case .onAppear(let channelId):
            self.input.onAppear.send(channelId)
        case .addUser:
            if userEmail.replacingOccurrences(of: " ", with: "") != "" {
                self.input.addUser.send(userEmail)
            }
        }
    }
    
    init(chatRepository: ChatRepository = ChatRepositoryImpl()) {
        self.chatRepository = chatRepository
        
        input.onAppear
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
                self.chatRepository.getChannelNotices(channelId: $0)
                    .catch { _ -> Empty<[ChatNotice], Never> in
                        return .init()
                    }
            }
            .assign(to: \.notices, on: self)
            .store(in: &bag)
        
        input.onAppear
            .flatMap {
                self.chatRepository.getChannelFiles(channelId: $0)
                    .catch { _ -> Empty<[ChatMessage], Never> in
                        return .init()
                    }
            }
            .assign(to: \.files, on: self)
            .store(in: &bag)
        
        input.addUser
            .flatMap {
                self.chatRepository.addUser(channelId: self.channel.id,
                                            email: $0)
                    .catch { _ -> Empty<Void, Never> in
                        return .init()
                    }
            }
            .sink(receiveValue: { _ in
                self.apply(.onAppear(channelId: self.channel.id))
            })
            .store(in: &bag)
    }
}
