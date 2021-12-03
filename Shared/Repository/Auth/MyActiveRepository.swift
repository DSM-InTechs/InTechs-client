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
            .retryWithAuthIfNeeded()
            .mapError {  NetworkError($0) }
            .eraseToAnyPublisher()
    }
#endif
    
    public func updateMyActive(isActive: Bool) -> AnyPublisher<Void, NetworkError> {
        provider.requestVoidPublisher(.updateMyActive(isActive: isActive))
            .retryWithAuthIfNeeded()
            .mapError { NetworkError($0) }
            .eraseToAnyPublisher()
    }
}
