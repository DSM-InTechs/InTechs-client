//
//  ChannelSearchViewModel.swift
//  InTechs
//
//  Created by GoEun Jeong on 2021/12/05.
//

import SwiftUI
import Combine

class ChannelSearchViewModel: ObservableObject {
    @Published var text = ""
    @Published var messages = [ChatMessage]()
    
    private let chatRepository: ChatRepository
    
    private var channelId = ""
    private var bag = Set<AnyCancellable>()
    
    public enum Event {
        case onAppear(channelId: String)
        case search
    }
    
    public struct Input {
        let search = PassthroughSubject<Void, Never>()
    }
    
    public let input = Input()
    
    public func apply(_ input: Event) {
        switch input {
        case .onAppear(let channelId):
            self.channelId = channelId
        case .search:
            self.input.search.send(())
        }
    }
    
    init(chatRepository: ChatRepository = ChatRepositoryImpl()) {
        self.chatRepository = chatRepository
        
        input.search
            .flatMap {
                self.chatRepository.searchMessage(channelId: self.channelId, message: self.text)
                    .catch { _ -> Empty<[ChatMessage], Never> in
                        return .init()
                    }
            }
            .assign(to: \.messages, on: self)
            .store(in: &bag)
    }
}
