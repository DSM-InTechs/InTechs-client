//
//  NewChannelViewModel.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/12/01.
//

import SwiftUI
import Combine

class NewChannelViewModel: ObservableObject {
    @Published var name = ""
    
    private let chatRepository: ChatRepository
    
    private var bag = Set<AnyCancellable>()
    
    public enum Event {
        case create
    }
    
    public struct Input {
        let create = PassthroughSubject<String, Never>()
    }
    
    public let input = Input()
    
    public func apply(_ input: Event) {
        switch input {
        case .create:
            self.input.create.send(self.name)
        }
    }
    
    init(chatRepository: ChatRepository = ChatRepositoryImpl()) {
        self.chatRepository = chatRepository
        
        input.create
            .flatMap {
                self.chatRepository.createChannel(name: $0)
                    .catch { _ -> Empty<Void, Never> in
                        return .init()
                    }
            }
            .sink(receiveValue: { _ in })
            .store(in: &bag)
    }
}
