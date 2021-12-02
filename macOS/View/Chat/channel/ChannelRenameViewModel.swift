//
//  ChannelRenameViewModel.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/12/01.
//

import SwiftUI
import Combine

class ChannelRenameViewModel: ObservableObject {
    @Published var originalName = ""
    @Published var originalImage: NSImage?
    
    @Published var updatedName: String = ""
    @Published var updatedImage: NSImage?
    
    private var channel = RoomInfo(id: "", name: "", image: "", users: [RoomUser](), notification: false, dm: false)
    
    private let chatRepository: ChatRepository
    
    private var bag = Set<AnyCancellable>()
    
    public enum Event {
        case getChannel(channel: RoomInfo)
        case change
    }
    
    public struct Input {
        let change = PassthroughSubject<String, Never>()
    }
    
    public let input = Input()
    
    public func apply(_ input: Event) {
        switch input {
        case .change:
            if self.updatedName != originalName || self.updatedImage != nil { // 변경 사항이 하나라도 있다면
                self.input.change.send(channel.id)
            }
        case .getChannel(let channel):
            self.originalName = channel.name
            self.updatedName = channel.name
            self.originalImage = NSImage(byReferencing: URL(string:  channel.image)!)
            self.channel = channel
        }
    }
    
    init(chatRepository: ChatRepository = ChatRepositoryImpl()) {
        self.chatRepository = chatRepository
        
        input.change
            .flatMap {
                self.chatRepository.updateChannel(channelId: $0,
                                                  name: self.updatedName,
                                                  image: self.updatedImage ?? self.originalImage!)
                    .catch { _ -> Empty<Void, Never> in
                        return .init()
                    }
            }
            .sink(receiveValue: { _ in })
            .store(in: &bag)
    }
}
