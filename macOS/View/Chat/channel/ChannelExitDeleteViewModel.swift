//
//  ChannelDeleteExitViewModel.swift
//  InTechs
//
//  Created by GoEun Jeong on 2021/12/03.
//

import SwiftUI
import Combine

class ChannelExitDeleteViewModel: ObservableObject {
    private var channel = RoomInfo(id: "", name: "", image: "", users: [RoomUser](), notification: false, dm: false)
    
    private let chatRepository: ChatRepository
    
    private var bag = Set<AnyCancellable>()
    
    public enum Event {
        case getChannel(channel: RoomInfo)
        case exit
        case delete
    }
    
    public struct Input {
        let exit = PassthroughSubject<Void, Never>()
        let delete = PassthroughSubject<Void, Never>()
    }
    
    public let input = Input()
    
    public func apply(_ input: Event) {
        switch input {
        case .exit:
            self.input.exit.send(())
        case .delete:
            self.input.delete.send(())
        case .getChannel(let channel):
            self.channel = channel
        }
    }
    
    init(chatRepository: ChatRepository = ChatRepositoryImpl()) {
        self.chatRepository = chatRepository
        
        input.exit
            .flatMap {
                self.chatRepository.exitChannel(channelId: self.channel.id)
                    .catch { _ -> Empty<Void, Never> in
                        return .init()
                    }
            }
            .sink(receiveValue: { _ in })
            .store(in: &bag)
        
        input.delete
            .flatMap {
                self.chatRepository.deleteChannel(channelId: self.channel.id)
                    .catch { _ -> Empty<Void, Never> in
                        return .init()
                    }
            }
            .sink(receiveValue: { _ in })
            .store(in: &bag)
    }
}
