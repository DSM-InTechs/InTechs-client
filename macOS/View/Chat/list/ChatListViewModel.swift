//
//  ChatViewModel.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/22.
//

import SwiftUI
import Combine

class ChatListViewModel: ObservableObject {
    @Published var selectedTab: ChatTab = .home
    
    @Published var selectedHome: Int? = 0
    @Published var homes = [ChatRoom]()
    
    @Published var selectedDM: Int? = 0
    @Published var DMs = [ChatRoom]()
    
    @Published var selectedChannel: Int? = 0
    @Published var channels = [ChatRoom]()
    
    private let chatRepository: ChatRepository
    
    private var bag = Set<AnyCancellable>()
    
    public enum Event {
        case onAppear
    }
    
    public struct Input {
        let onAppear = PassthroughSubject<Void, Never>()
    }
    
    public let input = Input()
    
    public func apply(_ input: Event) {
        switch input {
        case .onAppear:
            self.input.onAppear.send(())
        }
    }
    
    init(chatRepository: ChatRepository = ChatRepositoryImpl()) {
        self.chatRepository = chatRepository
        
        input.onAppear
            .flatMap {
                self.chatRepository.getChatlist()
                    .catch { _ -> Empty<[ChatRoom], Never> in
                        return .init()
                    }
            }
            .sink(receiveValue: {
                self.homes = $0
                self.channels = $0.filter { $0.isDM == false }
                self.DMs = $0.filter { $0.isDM == true }
            })
            .store(in: &bag)
        
        NotificationCenter.default
            .publisher(for: Notification.Name("Home"))
            .sink(receiveValue: { _ in
                self.apply(.onAppear)
            }).store(in: &bag)
    }
}
