//
//  MessageViewModel.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/12/03.
//

import SwiftUI
import Combine

class MessageViewModel: ObservableObject {
    
    private let chatRepository: ChatRepository
    
    private var bag = Set<AnyCancellable>()
    
    public enum Event {
        case setNotice(messageId: String)
    }
    
    public struct Input {
        let setNotice = PassthroughSubject<String, Never>()
    }
    
    public let input = Input()
    
    public func apply(_ input: Event) {
        switch input {
        case .setNotice(let messageId):
            self.input.setNotice.send(messageId)
        }
    }
    
    init(chatRepository: ChatRepository = ChatRepositoryImpl()) {
        self.chatRepository = chatRepository
        
        input.setNotice
            .flatMap {
                self.chatRepository.createNotice(messageId: $0)
                    .catch { _ -> Empty<Void, Never> in
                        return .init()
                    }
            }
            .sink(receiveValue: { _ in })
            .store(in: &bag)
    }
}
