//
//  CalendarRepository.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/10/21.
//

import Moya
import Combine

public protocol CalendarRepository {
    func getCalendar(year: String, month: String) -> AnyPublisher<[CalendarIssue], NetworkError>
    func getCalendar(year: String, month: String, tags: [String]?, users: [String]?, states: [String]?) -> AnyPublisher<[CalendarIssue], NetworkError>
}

final public class CalendarRepositoryImpl: CalendarRepository {
    private let provider: MoyaProvider<InTechsAPI>
    private let refreshRepository: RefreshRepository
    
    @UserDefault(key: "currentProject", defaultValue: 0)
    private var currentProject: Int
    
    public init(provider: MoyaProvider<InTechsAPI> = MoyaProvider<InTechsAPI>(),
                refreshRepository: RefreshRepository = RefreshRepositoryImpl()) {
        self.provider = provider
        self.refreshRepository = refreshRepository
    }
    
    public func getCalendar(year: String, month: String) -> AnyPublisher<[CalendarIssue], NetworkError> {
        provider.requestPublisher(.getCalendar(projectId: currentProject, year: year, month: month, tags: nil, states: nil, users: nil))
            .map([CalendarIssue].self)
            .retryWithAuthIfNeeded()
            .mapError {  NetworkError($0) }
            .eraseToAnyPublisher()
    }
    
    public func getCalendar(year: String, month: String, tags: [String]?, users: [String]?, states: [String]?) -> AnyPublisher<[CalendarIssue], NetworkError> {
        provider.requestPublisher(.getCalendar(projectId: currentProject, year: year, month: month, tags: tags, states: users, users: states))
            .map([CalendarIssue].self)
            .retryWithAuthIfNeeded()
            .mapError {  NetworkError($0) }
            .eraseToAnyPublisher()
    }
}
