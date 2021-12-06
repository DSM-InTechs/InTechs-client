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
    @Published var userEmail = ""
    
    private let chatRepository: ChatRepository
    
    private var bag = Set<AnyCancellable>()
    
    public enum Event {
        case channel
        case dm
    }
    
    public struct Input {
        let channel = PassthroughSubject<Void, Never>()
        let dm = PassthroughSubject<Void, Never>()
        let addUser = PassthroughSubject<String, Never>()
    }
    
    public let input = Input()
    
    public func apply(_ input: Event) {
        switch input {
        case .channel:
            self.input.channel.send(())
        case .dm:
            self.input.dm.send(())
        }
    }
    
    init(chatRepository: ChatRepository = ChatRepositoryImpl()) {
        self.chatRepository = chatRepository
        
        input.channel
            .flatMap {
                self.chatRepository.createChannel(name: self.name, isDM: false)
                    .catch { _ -> Empty<NewChannelResponse, Never> in
                        return .init()
                    }
            }
            .sink(receiveValue: { _ in })
            .store(in: &bag)
        
        input.dm
            .flatMap {
                self.chatRepository.createChannel(name: "", isDM: true)
                    .catch { _ -> Empty<NewChannelResponse, Never> in
                        return .init()
                    }
            }
            .sink(receiveValue: {
                self.input.addUser.send($0.channelId)
            })
            .store(in: &bag)
        
        input.addUser
            .flatMap {
                self.chatRepository.addUser(channelId: $0, email: self.userEmail)
                    .catch { _ -> Empty<Void, Never> in
                        return .init()
                    }
            }
            .sink(receiveValue: { _ in })
            .store(in: &bag)
    }
}
