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
    func getIssues(tags: [String]?, users: [String]?, states: [String]?) -> AnyPublisher<[Issue], NetworkError>
    func getUserlist() -> AnyPublisher<[IssueUser], NetworkError>
    func getTaglist() -> AnyPublisher<[IssueTag], NetworkError>
    func createIssue(title: String, body: String?, date: String?, progress: Int?, state: String?, users: [String]?, tags: [String]?) -> AnyPublisher<Void, NetworkError>
    func modifyIssue(id: String, title: String, body: String?, date: String?, progress: Int?, state: String?, users: [String]?, tags: [String]?) -> AnyPublisher<Void, NetworkError>
    func deleteIssue(id: String) -> AnyPublisher<Void, NetworkError>
    func getDetailIssue(id: String) -> AnyPublisher<Issue, NetworkError>
    func addComment(id: String, content: String) -> AnyPublisher<Void, NetworkError>
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
    
    public func getIssues(tags: [String]?, users: [String]?, states: [String]?) -> AnyPublisher<[Issue], NetworkError> {
        provider.requestPublisher(.getIssues(projectId: currentProject, tags: tags, states: states, users: users))
            .map([Issue].self)
            .tryCatch { error -> AnyPublisher<[Issue], MoyaError> in
                let networkError = NetworkError(error)
                if networkError == .unauthorized || networkError == .notMatch {
                    print("TOKEN ERROR")
                    self.refreshRepository.refresh()

                    return self.provider.requestPublisher(.getIssues(projectId: self.currentProject, tags: tags, states: states, users: users))
                        .map([Issue].self)
                }
                return Fail<[Issue], MoyaError>(error: error).eraseToAnyPublisher()
            }
            .mapError {  NetworkError($0) }
            .eraseToAnyPublisher()
    }
    
    public func getUserlist() -> AnyPublisher<[IssueUser], NetworkError> {
        provider.requestPublisher(.getIssueUsers(projectId: currentProject))
            .map([IssueUser].self)
            .tryCatch { error -> AnyPublisher<[IssueUser], MoyaError> in
                let networkError = NetworkError(error)
                if networkError == .unauthorized || networkError == .notMatch {
                    print("TOKEN ERROR")
                    self.refreshRepository.refresh()

                    return self.provider.requestPublisher(.getIssueUsers(projectId: self.currentProject))
                        .map([IssueUser].self)
                }
                return Fail<[IssueUser], MoyaError>(error: error).eraseToAnyPublisher()
            }
            .mapError {  NetworkError($0) }
            .eraseToAnyPublisher()
    }
    
    public func getTaglist() -> AnyPublisher<[IssueTag], NetworkError> {
        provider.requestPublisher(.getIssueTags(projectId: currentProject))
            .map([IssueTag].self)
            .tryCatch { error -> AnyPublisher<[IssueTag], MoyaError> in
                let networkError = NetworkError(error)
                if networkError == .unauthorized || networkError == .notMatch {
                    print("TOKEN ERROR")
                    self.refreshRepository.refresh()

                    return self.provider.requestPublisher(.getIssueTags(projectId: self.currentProject))
                        .map([IssueTag].self)
                }
                return Fail<[IssueTag], MoyaError>(error: error).eraseToAnyPublisher()
            }
            .mapError {  NetworkError($0) }
            .eraseToAnyPublisher()
    }
    
    public func createIssue(title: String, body: String?, date: String?, progress: Int?, state: String?, users: [String]?, tags: [String]?) -> AnyPublisher<Void, NetworkError> {
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
    
    public func modifyIssue(id: String, title: String, body: String?, date: String?, progress: Int?, state: String?, users: [String]?, tags: [String]?) -> AnyPublisher<Void, NetworkError> {
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
    
    public func deleteIssue(id: String) -> AnyPublisher<Void, NetworkError> {
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
    
    public func getDetailIssue(id: String) -> AnyPublisher<Issue, NetworkError> {
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
    
    public func addComment(id: String, content: String) -> AnyPublisher<Void, NetworkError> {
        provider.requestVoidPublisher(.addComment(issueId: id, content: content))
            .tryCatch { error -> AnyPublisher<Void, MoyaError> in
                let networkError = NetworkError(error)
                if networkError == .unauthorized || networkError == .notMatch {
                    print("TOKEN ERROR")
                    self.refreshRepository.refresh()

                    return self.provider.requestVoidPublisher(.addComment(issueId: id, content: content))
                }
                return Fail<Void, MoyaError>(error: error).eraseToAnyPublisher()
            }
            .mapError {  NetworkError($0) }
            .eraseToAnyPublisher()
    }
}
