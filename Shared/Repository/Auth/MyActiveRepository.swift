//
//  MyActiveRepository.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/10/06.
//

import Moya
import Combine

public protocol MyActiveRepository {
#if os(iOS)
    func updateMyActiveAsync(isActive: Bool) async -> AnyPublisher<Void, NetworkError>
#endif
    func updateMyActive(isActive: Bool) -> AnyPublisher<Void, NetworkError>
}

final public class MyActiveRepositoryImpl: MyActiveRepository {
    private let provider: MoyaProvider<InTechsAPI>
    private let refreshRepository: RefreshRepository
    
    public init(provider: MoyaProvider<InTechsAPI> = MoyaProvider<InTechsAPI>(),
                refreshRepository: RefreshRepository = RefreshRepositoryImpl()) {
        self.provider = provider
        self.refreshRepository = refreshRepository
    }
    
#if os(iOS)
    public func updateMyActiveAsync(isActive: Bool) async -> AnyPublisher<Void, NetworkError> {
        provider.requestVoidPublisher(.updateMyActive(isActive: isActive))
            .mapError {  NetworkError($0) }
            .eraseToAnyPublisher()
    }
#endif
    
    public func updateMyActive(isActive: Bool) -> AnyPublisher<Void, NetworkError> {
        provider.requestVoidPublisher(.updateMyActive(isActive: isActive))
            .tryCatch { error -> AnyPublisher<Void, MoyaError> in
                if NetworkError(error) == .unauthorized || NetworkError(error) == .notMatch {
                    print("MYACTIVE TOKEN ERROR")
                    self.refreshRepository.refresh()
                    return self.provider.requestVoidPublisher(.updateMyActive(isActive: isActive))
                        .eraseToAnyPublisher()
                }
                return Fail<Void, MoyaError>(error: error).eraseToAnyPublisher()
            }
            .mapError { NetworkError($0) }
            .eraseToAnyPublisher()
    }
}
