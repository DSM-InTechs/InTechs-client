//
//  ChannelInfoViewModel.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/12/06.
//

import SwiftUI
import Combine

class ChannelInfoViewModel: ObservableObject {
    @Published var channel = RoomInfo(id: "", name: "", image: "", users: [RoomUser](), notification: false, dm: false)
    @Published var notices = [ChatNotice]()
    @Published var files = [ChatMessage]()
    
    private let chatRepository: ChatRepository
    
    private var channelId = ""
    
    private var bag = Set<AnyCancellable>()
    
    public enum Event {
        case onAppear(channelId: String)
        case getNotices
        case getFiles
    }
    
    public struct Input {
        let onAppear = PassthroughSubject<String, Never>()
        let getNotices = PassthroughSubject<Void, Never>()
        let getFiles = PassthroughSubject<Void, Never>()
    }
    
    public let input = Input()
    
    public func apply(_ input: Event) {
        switch input {
        case .onAppear(let channelId):
            self.channelId = channelId
            self.input.onAppear.send(channelId)
        case .getNotices:
            self.input.getNotices.send(())
        case .getFiles:
            self.input.getFiles.send(())
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
        
        input.getNotices
            .flatMap {
                self.chatRepository.getChannelNotices(channelId: self.channelId)
                    .catch { _ -> Empty<[ChatNotice], Never> in
                        return .init()
                    }
            }
            .assign(to: \.notices, on: self)
            .store(in: &bag)
        
        input.getFiles
            .flatMap {
                self.chatRepository.getChannelFiles(channelId: self.channelId)
                    .catch { _ -> Empty<[ChatMessage], Never> in
                        return .init()
                    }
            }
            .assign(to: \.files, on: self)
            .store(in: &bag)
    }
}
