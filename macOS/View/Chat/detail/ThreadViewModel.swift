//
//  ThreadViewModel.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/11/23.
//

import SwiftUI
import Combine
import SocketIO

class ThreadViewModel: ObservableObject {
    @Published var text: String = ""
    
    private let chatRepository: ChatRepository
    
    private var socketManager = SocketIOManager.shared
    private var channelId = ""
    
    private var bag = Set<AnyCancellable>()
    
    @UserDefault(key: "accessToken", defaultValue: "")
    private var accessToken: String
    
    public enum Event {
        case addThread(messageId: String)
    }
    
    public struct Input {
        let setNotice = PassthroughSubject<String, Never>()
    }
    
    public let input = Input()
    
    public func apply(_ input: Event) {
        switch input {
        case let .addThread(messageId):
            self.pushMessage(messageId: messageId)
        }
    }
    
    init(chatRepository: ChatRepository = ChatRepositoryImpl()) {
        self.chatRepository = chatRepository
    }
    
    private func pushMessage(messageId: String) {
        if self.text.replacingOccurrences(of: " ", with: "") != "" {
            self.socketManager.emit(.sendThreadMessage(channelId: self.channelId, messageId: messageId, message: self.text))
        }
        self.text = ""
    }
    
}
