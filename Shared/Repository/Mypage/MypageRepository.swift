//
//  MypageRepository.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/10/07.
//

import Moya
import Combine

public protocol MypageRepository {
    func mypage() -> AnyPublisher<Mypage, NetworkError>
    func logout()
    func deleteUser() -> AnyPublisher<Void, NetworkError>
    #if os(iOS)
    func updateMypage(name: String, image: UIImage) -> AnyPublisher<Void, NetworkError>
    #elseif os(macOS)
    func updateMypage(name: String, image: NSImage) -> AnyPublisher<Void, NetworkError>
    #endif
}

final public class MypageRepositoryImpl: MypageRepository {
    private let provider: MoyaProvider<InTechsAPI>
    private let refreshRepository: RefreshRepository
    
    public init(provider: MoyaProvider<InTechsAPI> = MoyaProvider<InTechsAPI>(),
                refreshRepository: RefreshRepository = RefreshRepositoryImpl()) {
        self.provider = provider
        self.refreshRepository = refreshRepository
    }
    
    @UserDefault(key: "accessToken", defaultValue: "")
    private var accessToken: String
    
    @UserDefault(key: "refreshToken", defaultValue: "")
    private var refreshToken: String
    
    @UserDefault(key: "currentProject", defaultValue: 0)
    private var currentProject: Int
    
    public func mypage() -> AnyPublisher<Mypage, NetworkError> {
        provider.requestPublisher(.mypage)
            .map(Mypage.self)
            .tryCatch { error -> AnyPublisher<Mypage, MoyaError> in
                let networkError = NetworkError(error)
                if networkError == .unauthorized || networkError == .notMatch {
                    self.refreshRepository.refresh()
                    
                    return self.provider.requestPublisher(.mypage)
                        .map(Mypage.self)
                }
                return Fail<Mypage, MoyaError>(error: error).eraseToAnyPublisher()
            }
            .mapError {  NetworkError($0) }
            .eraseToAnyPublisher()
    }
    
    public func logout() {
        self.accessToken = ""
        self.refreshToken = ""
        self.currentProject = 0
    }
    
    public func deleteUser() -> AnyPublisher<Void, NetworkError> {
        provider.requestVoidPublisher(.deleteUser)
            .tryCatch { error -> AnyPublisher<Void, MoyaError> in
                if NetworkError(error) == .unauthorized || NetworkError(error) == .notMatch {
                    self.refreshRepository.refresh()
                    
                    return self.provider.requestVoidPublisher(.deleteUser)
                }
                return Fail<Void, MoyaError>(error: error).eraseToAnyPublisher()
            }
            .mapError {  NetworkError($0) }
            .eraseToAnyPublisher()
    }
    
    #if os(iOS)
    public func updateMypage(name: String, image: UIImage) -> AnyPublisher<Void, NetworkError> {
        let image = image.resize(width: 400, height: 400)
        let data = image.jpegData(compressionQuality: 1)!
        
        return provider.requestVoidPublisher(.updateMypage(name: name, imageData: data))
            .tryCatch { error -> AnyPublisher<Void, MoyaError> in
                let networkError = NetworkError(error)
                if networkError == .unauthorized || networkError == .notMatch {
                    self.refreshRepository.refresh()
                    return self.provider.requestVoidPublisher(.updateMypage(name: name, imageData: data))
                        .eraseToAnyPublisher()
                }
                return Fail<Void, MoyaError>(error: error).eraseToAnyPublisher()
            }
            .mapError {  NetworkError($0) }
            .eraseToAnyPublisher()
    }
    #elseif os(macOS)
    public func updateMypage(name: String, image: NSImage) -> AnyPublisher<Void, NetworkError> {
        let image = image.resize(width: 400, height: 400)!
        let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil)!
        let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
        let jpegData = bitmapRep.representation(using: NSBitmapImageRep.FileType.jpeg, properties: [:])!
        
        return provider.requestVoidPublisher(.updateMypage(name: name, imageData: jpegData))
            .tryCatch { error -> AnyPublisher<Void, MoyaError> in
                let networkError = NetworkError(error)
                if networkError == .unauthorized || networkError == .notMatch {
                    self.refreshRepository.refresh()
                    return self.provider.requestVoidPublisher(.updateMypage(name: name, imageData: jpegData))
                        .eraseToAnyPublisher()
                }
                return Fail<Void, MoyaError>(error: error).eraseToAnyPublisher()
            }
            .mapError {  NetworkError($0) }
            .eraseToAnyPublisher()
    }
    #endif
}
