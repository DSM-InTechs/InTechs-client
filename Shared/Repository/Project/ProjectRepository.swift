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
    func getProjectInfo() -> AnyPublisher<ProjectInfo, NetworkError>
    func getProjectDashBoard() -> AnyPublisher<ProjectDashboard, NetworkError>
    func getProjectMembers() -> AnyPublisher<[ProjectMember], NetworkError>
    func exitProject() -> AnyPublisher<Void, NetworkError>
    func deleteProject() -> AnyPublisher<Void, NetworkError>
    #if os(iOS)
    func createProject(name: String, image: UIImage) -> AnyPublisher<Void, NetworkError>
    func updateProject(name: String, image: UIImage) -> AnyPublisher<Void, NetworkError>
    #elseif os(macOS)
    func createProject(name: String, image: NSImage) -> AnyPublisher<Void, NetworkError>
    func updateProject(name: String, image: NSImage) -> AnyPublisher<Void, NetworkError>
    #endif
}

final public class ProjectRepositoryImpl: ProjectRepository {
    private let provider: MoyaProvider<InTechsAPI>
    private let refreshRepository: RefreshRepository
    
    @UserDefault(key: "currentProject", defaultValue: 0)
    private var currentProject: Int
    
    public init(provider: MoyaProvider<InTechsAPI> = MoyaProvider<InTechsAPI>(),
                refreshRepository: RefreshRepository = RefreshRepositoryImpl()) {
        self.provider = provider
        self.refreshRepository = refreshRepository
    }
    
    public func myProjects() -> AnyPublisher<[Project], NetworkError> {
        provider.requestPublisher(.getMyProjects)
            .map([Project].self)
            .map {
                if self.currentProject == 0 && !$0.isEmpty { // 만약 현재 프로젝트가 없을 경우 첫번째 프로젝트 할당.
                    self.currentProject = $0.first!.id
                }
                return $0
            }
            .tryCatch { error -> AnyPublisher<[Project], MoyaError> in
                let networkError = NetworkError(error)
                if networkError == .unauthorized || networkError == .notMatch {
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
            .map {
                self.currentProject = number
            }
            .tryCatch { error -> AnyPublisher<Void, MoyaError> in
                let networkError = NetworkError(error)
                if networkError == .unauthorized || networkError == .notMatch {
                    self.refreshRepository.refresh()
                    
                    return self.provider.requestVoidPublisher(.joinProject(id: number))
                }
                return Fail<Void, MoyaError>(error: error).eraseToAnyPublisher()
            }
            .mapError {  NetworkError($0) }
            .eraseToAnyPublisher()
    }
    
    public func getProjectInfo() -> AnyPublisher<ProjectInfo, NetworkError> {
        provider.requestPublisher(.getProjectInfo(id: currentProject))
            .map(ProjectInfo.self)
            .tryCatch { error -> AnyPublisher<ProjectInfo, MoyaError> in
                let networkError = NetworkError(error)
                if networkError == .unauthorized || networkError == .notMatch {
                    print("TOKEN ERROR")
                    self.refreshRepository.refresh()
                    
                    return self.provider.requestPublisher(.getProjectInfo(id: self.currentProject))
                        .map(ProjectInfo.self)
                }
                return Fail<ProjectInfo, MoyaError>(error: error).eraseToAnyPublisher()
            }
            .mapError {  NetworkError($0) }
            .eraseToAnyPublisher()
    }
    
    public func getProjectDashBoard() -> AnyPublisher<ProjectDashboard, NetworkError> {
        provider.requestPublisher(.dashboard(id: currentProject))
            .map(ProjectDashboard.self)
            .tryCatch { error -> AnyPublisher<ProjectDashboard, MoyaError> in
                let networkError = NetworkError(error)
                if networkError == .unauthorized || networkError == .notMatch {
                    print("TOKEN ERROR")
                    self.refreshRepository.refresh()
                    
                    return self.provider.requestPublisher(.dashboard(id: self.currentProject))
                        .map(ProjectDashboard.self)
                }
                return Fail<ProjectDashboard, MoyaError>(error: error).eraseToAnyPublisher()
            }
            .mapError {  NetworkError($0) }
            .eraseToAnyPublisher()
    }
    
    public func getProjectMembers() -> AnyPublisher<[ProjectMember], NetworkError> {
        provider.requestPublisher(.getProjectMembers(id: currentProject))
            .map([ProjectMember].self)
            .tryCatch { error -> AnyPublisher<[ProjectMember], MoyaError> in
                let networkError = NetworkError(error)
                if networkError == .unauthorized || networkError == .notMatch {
                    print("TOKEN ERROR")
                    self.refreshRepository.refresh()
                    
                    return self.provider.requestPublisher(.getProjectMembers(id: self.currentProject))
                        .map([ProjectMember].self)
                }
                return Fail<[ProjectMember], MoyaError>(error: error).eraseToAnyPublisher()
            }
            .mapError {  NetworkError($0) }
            .eraseToAnyPublisher()
    }
    
    public func exitProject() -> AnyPublisher<Void, NetworkError> {
        provider.requestVoidPublisher(.exitProject(id: currentProject))
            .tryCatch { error -> AnyPublisher<Void, MoyaError> in
                let networkError = NetworkError(error)
                if networkError == .unauthorized || networkError == .notMatch {
                    self.refreshRepository.refresh()
                    
                    return self.provider.requestVoidPublisher(.deleteProject(id: self.currentProject))
                }
                return Fail<Void, MoyaError>(error: error).eraseToAnyPublisher()
            }
            .mapError {  NetworkError($0) }
            .eraseToAnyPublisher()
    }
    
    public func deleteProject() -> AnyPublisher<Void, NetworkError> {
        provider.requestVoidPublisher(.deleteProject(id: currentProject))
            .tryCatch { error -> AnyPublisher<Void, MoyaError> in
                let networkError = NetworkError(error)
                if networkError == .unauthorized || networkError == .notMatch {
                    self.refreshRepository.refresh()
                    
                    return self.provider.requestVoidPublisher(.deleteProject(id: self.currentProject))
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
        
        return provider.requestPublisher(.createProject(name: name, imageData: data))
            .map { moyaResponse -> Void in
                let response = moyaResponse.response
                let responseHeader = response?.allHeaderFields
                let str = responseHeader!["Project-Number"] as! NSString
                self.currentProject = Int(str.intValue)
                return
            }
            .tryCatch { error -> AnyPublisher<Void, MoyaError> in
                let networkError = NetworkError(error)
                if networkError == .unauthorized || networkError == .notMatch {
                    self.refreshRepository.refresh()
                    return self.provider.requestVoidPublisher(.createProject(name: name, imageData: data))
                }
                return Fail<Void, MoyaError>(error: error).eraseToAnyPublisher()
            }
            .mapError {  NetworkError($0) }
            .eraseToAnyPublisher()
    }
    
    public func updateProject(name: String, image: UIImage) -> AnyPublisher<Void, NetworkError> {
        let image = image.resize(width: 400, height: 400)
        let data = image.jpegData(compressionQuality: 1)!
        
        return provider.requestVoidPublisher(.updateProject(id: currentProject, name: name, imageData: data))
            .tryCatch { error -> AnyPublisher<Void, MoyaError> in
                let networkError = NetworkError(error)
                if networkError == .unauthorized || networkError == .notMatch {
                    self.refreshRepository.refresh()
                    return self.provider.requestVoidPublisher(.updateProject(id: self.currentProject, name: name, imageData: data))
                }
                return Fail<Void, MoyaError>(error: error).eraseToAnyPublisher()
            }
            .mapError {  NetworkError($0) }
            .eraseToAnyPublisher()
    }
    
    #elseif os(macOS)
    
    public func createProject(name: String, image: NSImage) -> AnyPublisher<Void, NetworkError> {
        let image = image.resize(width: 400, height: 400)!
        let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil)!
        let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
        let jpegData = bitmapRep.representation(using: NSBitmapImageRep.FileType.jpeg, properties: [:])!
        
        return provider.requestPublisher(.createProject(name: name, imageData: jpegData))
            .map { moyaResponse -> Void in
                let response = moyaResponse.response
                let responseHeader = response?.allHeaderFields
                let str = responseHeader!["Project-Number"] as! NSString
                self.currentProject = Int(str.intValue)
                return
            }
            .tryCatch { error -> AnyPublisher<Void, MoyaError> in
                let networkError = NetworkError(error)
                if networkError == .unauthorized || networkError == .notMatch {
                    self.refreshRepository.refresh()
                    
                    return self.provider.requestVoidPublisher(.createProject(name: name, imageData: data))
                }
                return Fail<Void, MoyaError>(error: error).eraseToAnyPublisher()
            }
            .mapError {  NetworkError($0) }
            .eraseToAnyPublisher()
    }
    
    public func updateProject(name: String, image: NSImage) -> AnyPublisher<Void, NetworkError> {
        let image = image.resize(width: 400, height: 400)!
        let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil)!
        let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
        let jpegData = bitmapRep.representation(using: NSBitmapImageRep.FileType.jpeg, properties: [:])!
        
        return provider.requestVoidPublisher(.updateProject(id: currentProject, name: name, imageData: jpegData))
            .tryCatch { error -> AnyPublisher<Void, MoyaError> in
                let networkError = NetworkError(error)
                if networkError == .unauthorized || networkError == .notMatch {
                    self.refreshRepository.refresh()
                    
                    return self.provider.requestVoidPublisher(.updateProject(id: self.currentProject, name: name, imageData: jpegData))
                }
                return Fail<Void, MoyaError>(error: error).eraseToAnyPublisher()
            }
            .mapError {  NetworkError($0) }
            .eraseToAnyPublisher()
    }
    
    #endif
}
