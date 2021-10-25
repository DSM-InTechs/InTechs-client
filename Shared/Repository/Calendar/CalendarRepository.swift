//
//  CalendarRepository.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/10/21.
//

import Moya
import Combine

public protocol CalendarRepository {
    func getCalendar() -> AnyPublisher<[Issue], NetworkError>
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
    
    public func getCalendar() -> AnyPublisher<[Issue], NetworkError> {
        provider.requestPublisher(.getCalendar(projectId: currentProject))
            .map([Issue].self)
            .tryCatch { error -> AnyPublisher<[Issue], MoyaError> in
                let networkError = NetworkError(error)
                if networkError == .unauthorized || networkError == .notMatch {
                    print("TOKEN ERROR")
                    self.refreshRepository.refresh()

                    return self.provider.requestPublisher(.getCalendar(projectId: self.currentProject))
                        .map([Issue].self)
                }
                return Fail<[Issue], MoyaError>(error: error).eraseToAnyPublisher()
            }
            .mapError {  NetworkError($0) }
            .eraseToAnyPublisher()
    }
}
