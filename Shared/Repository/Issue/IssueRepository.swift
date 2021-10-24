//
//  IssueRepository.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/10/20.
//

import Moya
import Combine

public protocol IssueReporitory {
    func getIssues() -> AnyPublisher<[Issue], NetworkError>
    func createIssue(title: String, body: String?, date: String?, progress: Int?, state: String?, users: [String]?, tags: [String]?) -> AnyPublisher<Void, NetworkError>
    func modifyIssue(id: Int, title: String, body: String?, date: String?, progress: Int?, state: String?, users: [String]?, tags: [String]?) -> AnyPublisher<Void, NetworkError>
    func deleteIssue(id: Int) -> AnyPublisher<Void, NetworkError>
    func getDetailIssue(id: Int) -> AnyPublisher<Issue, NetworkError>
}

final public class IssueReporitoryImpl: IssueReporitory {
    private let provider: MoyaProvider<InTechsAPI>
    private let refreshRepository: RefreshRepository
    
    @UserDefault(key: "currentProject", defaultValue: 0)
    private var currentProject: Int
    
    public init(provider: MoyaProvider<InTechsAPI> = MoyaProvider<InTechsAPI>(),
                refreshRepository: RefreshRepository = RefreshRepositoryImpl()) {
        self.provider = provider
        self.refreshRepository = refreshRepository
    }
    
    public func getIssues() -> AnyPublisher<[Issue], NetworkError> {
        provider.requestPublisher(.getIssues(projectId: currentProject, tags: nil, states: nil, users: nil))
            .map([Issue].self)
            .tryCatch { error -> AnyPublisher<[Issue], MoyaError> in
                let networkError = NetworkError(error)
                if networkError == .unauthorized || networkError == .notMatch {
                    print("TOKEN ERROR")
                    self.refreshRepository.refresh()

                    return self.provider.requestPublisher(.getIssues(projectId: self.currentProject, tags: nil, states: nil, users: nil))
                        .map([Issue].self)
                }
                return Fail<[Issue], MoyaError>(error: error).eraseToAnyPublisher()
            }
            .mapError {  NetworkError($0) }
            .eraseToAnyPublisher()
    }
    
    public func
    createIssue(title: String, body: String?, date: String?, progress: Int?, state: String?, users: [String]?, tags: [String]?) -> AnyPublisher<Void, NetworkError> {
        provider.requestVoidPublisher(.createIssue(projectId: currentProject, title: title, body: body, date: date, progress: progress, state: state, users: users, tags: tags))
            .tryCatch { error -> AnyPublisher<Void, MoyaError> in
                let networkError = NetworkError(error)
                if networkError == .unauthorized || networkError == .notMatch {
                    print("TOKEN ERROR")
                    self.refreshRepository.refresh()

                    return self.provider.requestVoidPublisher(.createIssue(projectId: self.currentProject,title: title, body: body, date: date, progress: progress, state: state, users: users, tags: tags))
                }
                return Fail<Void, MoyaError>(error: error).eraseToAnyPublisher()
            }
            .mapError {  NetworkError($0) }
            .eraseToAnyPublisher()
    }
    
    public func modifyIssue(id: Int, title: String, body: String?, date: String?, progress: Int?, state: String?, users: [String]?, tags: [String]?) -> AnyPublisher<Void, NetworkError> {
        provider.requestVoidPublisher(.updateIssue(projectId: currentProject, issueId: id, title: title, body: body, date: date, progress: progress, state: state, users: users, tags: tags))
            .tryCatch { error -> AnyPublisher<Void, MoyaError> in
                let networkError = NetworkError(error)
                if networkError == .unauthorized || networkError == .notMatch {
                    print("TOKEN ERROR")
                    self.refreshRepository.refresh()

                    return self.provider.requestVoidPublisher(.updateIssue(projectId: self.currentProject, issueId: id, title: title, body: body, date: date, progress: progress, state: state, users: users, tags: tags))
                }
                return Fail<Void, MoyaError>(error: error).eraseToAnyPublisher()
            }
            .mapError {  NetworkError($0) }
            .eraseToAnyPublisher()
    }
    
    public func deleteIssue(id: Int) -> AnyPublisher<Void, NetworkError> {
        provider.requestVoidPublisher(.deleteIssue(projectId: currentProject, issueId: id))
            .tryCatch { error -> AnyPublisher<Void, MoyaError> in
                let networkError = NetworkError(error)
                if networkError == .unauthorized || networkError == .notMatch {
                    print("TOKEN ERROR")
                    self.refreshRepository.refresh()

                    return self.provider.requestVoidPublisher(.deleteIssue(projectId: self.currentProject, issueId: id))
                }
                return Fail<Void, MoyaError>(error: error).eraseToAnyPublisher()
            }
            .mapError {  NetworkError($0) }
            .eraseToAnyPublisher()
    }
    
    public func getDetailIssue(id: Int) -> AnyPublisher<Issue, NetworkError> {
        provider.requestPublisher(.getDetailIssue(projectId: currentProject, issueId: id))
            .map(Issue.self)
            .tryCatch { error -> AnyPublisher<Issue, MoyaError> in
                let networkError = NetworkError(error)
                if networkError == .unauthorized || networkError == .notMatch {
                    print("TOKEN ERROR")
                    self.refreshRepository.refresh()

                    return self.provider.requestPublisher(.getDetailIssue(projectId: self.currentProject, issueId: id))
                        .map(Issue.self)
                }
                return Fail<Issue, MoyaError>(error: error).eraseToAnyPublisher()
            }
            .mapError {  NetworkError($0) }
            .eraseToAnyPublisher()
    }
}
