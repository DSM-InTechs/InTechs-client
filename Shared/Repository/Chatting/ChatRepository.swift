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
    func getChatInfo(channelId: String) -> AnyPublisher<RoomInfo, NetworkError>
    func getMessagelist(channelId: String, page: Int) -> AnyPublisher<MessageList, NetworkError>
    func getChannelUsers(channelId: String) -> AnyPublisher<[MessageSender], NetworkError>
    func getChannelNotices(channelId: String) -> AnyPublisher<[ChatNotice], NetworkError>
    
    func addUser(channelId: String, email: String) -> AnyPublisher<Void, NetworkError>
    
    func createNotice(messageId: String) -> AnyPublisher<Void, NetworkError>
    
    func createChannel(name: String, isDM: Bool) -> AnyPublisher<NewChannelResponse, NetworkError>
    func deleteChannel(channelId: String) -> AnyPublisher<Void, NetworkError>
    func exitChannel(channelId: String) -> AnyPublisher<Void, NetworkError>
#if os(iOS)
    func updateChannel(channelId: String, name: String, image: UIImage) -> AnyPublisher<Void, NetworkError>
#elseif os(macOS)
    func updateChannel(channelId: String, name: String, image: NSImage) -> AnyPublisher<Void, NetworkError>
#endif
    
    func updateNotification(channelId: String) -> AnyPublisher<Void, NetworkError>
    
    func sendImageMessage(channelId: String, name: String, image: NSImage) -> AnyPublisher<Void, NetworkError>
    func sendFileMessage(channelId: String, name: String, file: Data) -> AnyPublisher<Void, NetworkError>
    
    func searchMessage(channelId: String, message: String) -> AnyPublisher<[ChatMessage], NetworkError>
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
            .mapError { NetworkError($0) }
            .eraseToAnyPublisher()
    }
    
    public func getChatInfo(channelId: String) -> AnyPublisher<RoomInfo, NetworkError> {
        provider.requestPublisher(.getChatInfo(channelId: channelId))
            .map(RoomInfo.self)
            .retryWithAuthIfNeeded()
            .mapError { NetworkError($0) }
            .eraseToAnyPublisher()
    }
    
    public func getMessagelist(channelId: String, page: Int) -> AnyPublisher<MessageList, NetworkError> {
        provider.requestPublisher(.getMessageList(channelId: channelId, page: page))
            .map(MessageList.self)
            .retryWithAuthIfNeeded()
            .mapError { NetworkError($0) }
            .eraseToAnyPublisher()
    }
    
    public func getChannelUsers(channelId: String) -> AnyPublisher<[MessageSender], NetworkError> {
        provider.requestPublisher(.getChannelUsers(channelId: channelId))
            .map([MessageSender].self)
            .retryWithAuthIfNeeded()
            .mapError { NetworkError($0) }
            .eraseToAnyPublisher()
    }
    
    public func getChannelNotices(channelId: String) -> AnyPublisher<[ChatNotice], NetworkError> {
        provider.requestPublisher(.getNotices(channelId: channelId))
            .map([ChatNotice].self)
            .retryWithAuthIfNeeded()
            .mapError { NetworkError($0) }
            .eraseToAnyPublisher()
    }
    
    public func addUser(channelId: String, email: String) -> AnyPublisher<Void, NetworkError> {
        provider.requestVoidPublisher(.addChannelUser(projectId: self.currentProject, channelId: channelId, email: email))
            .retryWithAuthIfNeeded()
            .mapError { NetworkError($0) }
            .eraseToAnyPublisher()
    }
    
    public func createNotice(messageId: String) -> AnyPublisher<Void, NetworkError> {
        provider.requestVoidPublisher(.createNotice(messageId: messageId))
            .retryWithAuthIfNeeded()
            .mapError { NetworkError($0) }
            .eraseToAnyPublisher()
    }
    
    public func createChannel(name: String, isDM: Bool) -> AnyPublisher<NewChannelResponse, NetworkError> {
        provider.requestPublisher(.createChannel(projectId: self.currentProject, name: name, isDM: isDM))
            .map(NewChannelResponse.self)
            .retryWithAuthIfNeeded()
            .mapError { NetworkError($0) }
            .eraseToAnyPublisher()
    }
    
    public func deleteChannel(channelId: String) -> AnyPublisher<Void, NetworkError> {
        provider.requestVoidPublisher(.deleteChannel(projectId: self.currentProject, channelId: channelId))
            .retryWithAuthIfNeeded()
            .mapError { NetworkError($0) }
            .eraseToAnyPublisher()
    }
    
    public func exitChannel(channelId: String) -> AnyPublisher<Void, NetworkError> {
        provider.requestVoidPublisher(.exitChannel(projectId: self.currentProject, channelId: channelId))
            .retryWithAuthIfNeeded()
            .mapError { NetworkError($0) }
            .eraseToAnyPublisher()
    }
    
#if os(iOS)
    public func updateChannel(channelId: String, name: String, image: UIImage) -> AnyPublisher<Void, NetworkError> {
        let image = image.resize(width: 400, height: 400)
        let data = image.jpegData(compressionQuality: 1)!
        
        return provider.requestVoidPublisher(.updateChannel(projectId: self.currentProject, channelId: channelId, name: name, imageData: jpegData))
            .retryWithAuthIfNeeded()
            .mapError { NetworkError($0) }
            .eraseToAnyPublisher()
    }
    
#elseif os(macOS)
    public func updateChannel(channelId: String, name: String, image: NSImage) -> AnyPublisher<Void, NetworkError> {
        let image = image.resize(width: 400, height: 400)!
        let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil)!
        let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
        let jpegData = bitmapRep.representation(using: NSBitmapImageRep.FileType.jpeg, properties: [:])!
        
        return provider.requestVoidPublisher(.updateChannel(projectId: self.currentProject, channelId: channelId, name: name, imageData: jpegData))
            .retryWithAuthIfNeeded()
            .mapError { NetworkError($0) }
            .eraseToAnyPublisher()
    }
    
#endif
    
    public func updateNotification(channelId: String) -> AnyPublisher<Void, NetworkError> {
        return provider.requestVoidPublisher(.updateNotification(channelId: channelId))
            .retryWithAuthIfNeeded()
            .mapError { NetworkError($0) }
            .eraseToAnyPublisher()
    }
    
    public func sendImageMessage(channelId: String, name: String, image: NSImage) -> AnyPublisher<Void, NetworkError> {
        let image = image.resize(width: 500, height: 500)!
        let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil)!
        let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
        let jpegData = bitmapRep.representation(using: NSBitmapImageRep.FileType.jpeg, properties: [:])!
        
        return provider.requestVoidPublisher(.sendFileMessage(channelId: channelId, name: name, fileData: jpegData))
            .retryWithAuthIfNeeded()
            .mapError { NetworkError($0) }
            .eraseToAnyPublisher()
    }
    
    public func sendFileMessage(channelId: String, name: String, file: Data) -> AnyPublisher<Void, NetworkError> {
        return provider.requestVoidPublisher(.sendFileMessage(channelId: channelId, name: name, fileData: file))
            .retryWithAuthIfNeeded()
            .mapError { NetworkError($0) }
            .eraseToAnyPublisher()
    }
    
    public func searchMessage(channelId: String, message: String) -> AnyPublisher<[ChatMessage], NetworkError> {
        return provider.requestPublisher(.searchMessage(channelId: channelId, text: message))
            .map([ChatMessage].self)
            .retryWithAuthIfNeeded()
            .mapError { NetworkError($0) }
            .eraseToAnyPublisher()
    }
}
