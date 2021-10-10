//
//  MypageRepository.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/10/07.
//

import Moya
import Combine

public protocol ProjectRepository {
    func myProjects() -> AnyPublisher<[Project], NetworkError>
    func joinProject(number: Int) -> AnyPublisher<Void, NetworkError>
    #if os(iOS)
    func createProject(name: String, image: UIImage) -> AnyPublisher<Void, NetworkError>
    func updateProject(id: Int, name: String, image: UIImage) -> AnyPublisher<Void, NetworkError>
    #elseif os(macOS)
    func createProject(name: String, image: NSImage) -> AnyPublisher<Void, NetworkError>
    func updateProject(id: Int, name: String, image: NSImage) -> AnyPublisher<Void, NetworkError>
    #endif
}

final public class ProjectRepositoryImpl: ProjectRepository {
    private let provider: MoyaProvider<InTechsAPI>
    private let refreshRepository: RefreshRepository
    
    public init(provider: MoyaProvider<InTechsAPI> = MoyaProvider<InTechsAPI>(),
                refreshRepository: RefreshRepository = RefreshRepositoryImpl()) {
        self.provider = provider
        self.refreshRepository = refreshRepository
    }
    
    public func myProjects() -> AnyPublisher<[Project], NetworkError> {
        provider.requestPublisher(.getMyProjects)
            .map([Project].self)
            .tryCatch { error -> AnyPublisher<[Project], MoyaError> in
                if NetworkError(error) == .unauthorized || NetworkError(error) == .notMatch {
                    print("TOKEN ERROR")
                    self.refreshRepository.refresh()
                    
                    return self.provider.requestPublisher(.getMyProjects)
                        .map([Project].self)
                }
                return Fail<[Project], MoyaError>(error: error).eraseToAnyPublisher()
            }
            .mapError {  NetworkError($0) }
            .eraseToAnyPublisher()
    }
    
    public func joinProject(number: Int) -> AnyPublisher<Void, NetworkError> {
        provider.requestVoidPublisher(.joinProject(id: number))
            .tryCatch { error -> AnyPublisher<Void, MoyaError> in
                if NetworkError(error) == .unauthorized || NetworkError(error) == .notMatch {
                    self.refreshRepository.refresh()
                    
                    return self.provider.requestVoidPublisher(.joinProject(id: number))
                }
                return Fail<Void, MoyaError>(error: error).eraseToAnyPublisher()
            }
            .mapError {  NetworkError($0) }
            .eraseToAnyPublisher()
    }
    
    #if os(iOS)
    public func createProject(name: String, image: UIImage) -> AnyPublisher<Void, NetworkError> {
        let image = image.resize(width: 400, height: 400)
        let data = image.jpegData(compressionQuality: 1)!
        
        return provider.requestVoidPublisher(.createProject(id: id, name: name, imageData: data))
            .tryCatch { error -> AnyPublisher<Void, MoyaError> in
                if NetworkError(error) == .unauthorized || NetworkError(error) == .notMatch {
                    self.refreshRepository.refresh()
                    return self.provider.requestVoidPublisher(.updateMypage(name: name, imageData: data))
                }
                return Fail<Void, MoyaError>(error: error).eraseToAnyPublisher()
            }
            .mapError {  NetworkError($0) }
            .eraseToAnyPublisher()
    }
    
    public func updateProject(id: Int, name: String, image: UIImage) -> AnyPublisher<Void, NetworkError> {
        let image = image.resize(width: 400, height: 400)
        let data = image.jpegData(compressionQuality: 1)!
        
        return provider.requestVoidPublisher(.updateProject(id: id, name: name, imageData: data))
            .tryCatch { error -> AnyPublisher<Void, MoyaError> in
                if NetworkError(error) == .unauthorized || NetworkError(error) == .notMatch {
                    self.refreshRepository.refresh()
                    return self.provider.requestVoidPublisher(.updateMypage(name: name, imageData: data))
                }
                return Fail<Void, MoyaError>(error: error).eraseToAnyPublisher()
            }
            .mapError {  NetworkError($0) }
            .eraseToAnyPublisher()
    }
    
    #elseif os(macOS)
    
    public func createProject(name: String, image: NSImage) -> AnyPublisher<Void, NetworkError> {
        let image = image.resize(width: 400, height: 400)!
        let data = image.tiffRepresentation! as Data
        
        return provider.requestVoidPublisher(.createProject(name: name, imageData: data))
            .tryCatch { error -> AnyPublisher<Void, MoyaError> in
                if NetworkError(error) == .unauthorized || NetworkError(error) == .notMatch {
                    self.refreshRepository.refresh()
                    
                    return self.provider.requestVoidPublisher(.updateMypage(name: name, imageData: data))
                }
                return Fail<Void, MoyaError>(error: error).eraseToAnyPublisher()
            }
            .mapError {  NetworkError($0) }
            .eraseToAnyPublisher()
    }
    
    public func updateProject(id: Int, name: String, image: NSImage) -> AnyPublisher<Void, NetworkError> {
        let image = image.resize(width: 400, height: 400)!
        let data = image.tiffRepresentation! as Data
        
        return provider.requestVoidPublisher(.updateProject(id: id, name: name, imageData: data))
            .tryCatch { error -> AnyPublisher<Void, MoyaError> in
                if NetworkError(error) == .unauthorized || NetworkError(error) == .notMatch {
                    self.refreshRepository.refresh()
                    
                    return self.provider.requestVoidPublisher(.updateMypage(name: name, imageData: data))
                }
                return Fail<Void, MoyaError>(error: error).eraseToAnyPublisher()
            }
            .mapError {  NetworkError($0) }
            .eraseToAnyPublisher()
    }
    
    #endif
}
