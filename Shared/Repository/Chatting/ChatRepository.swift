//
//  ChatRepository.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/12/01.
//

import Moya
import Combine

public protocol ChatRepository {
    func getChatlist() -> AnyPublisher<[ChatRoom], NetworkError>
    func getMessagelist(channelId: Int, page: Int) -> AnyPublisher<MessageList, NetworkError>
}

final public class ChatRepositoryImpl: ChatRepository {
    private let provider: MoyaProvider<InTechsAPI>
    private let refreshRepository: RefreshRepository
    
    @UserDefault(key: "currentProject", defaultValue: 0)
    private var currentProject: Int
    
    public init(provider: MoyaProvider<InTechsAPI> = MoyaProvider<InTechsAPI>(),
                refreshRepository: RefreshRepository = RefreshRepositoryImpl()) {
        self.provider = provider
        self.refreshRepository = refreshRepository
    }
    
    public func getChatlist() -> AnyPublisher<[ChatRoom], NetworkError> {
        provider.requestPublisher(.getChatList(projectId: currentProject))
            .map([ChatRoom].self)
            .retryWithAuthIfNeeded()
            .mapError {  NetworkError($0) }
            .eraseToAnyPublisher()
    }
    
    public func getMessagelist(channelId: Int, page: Int) -> AnyPublisher<MessageList, NetworkError> {
        provider.requestPublisher(.getMessageList(channelId: channelId, page: page))
            .map(MessageList.self)
            .retryWithAuthIfNeeded()
            .mapError {  NetworkError($0) }
            .eraseToAnyPublisher()
    }
    
}
