//
//  RegisterRepository.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/10/04.
//

import Moya
import Combine

public protocol RegisterRepository {
#if os(iOS)
    func registerAsync(name: String, email: String, password: String) async -> AnyPublisher<Void, NetworkError>
#endif
    func register(name: String, email: String, password: String) -> AnyPublisher<Void, NetworkError>
}

final public class RegisterRepositoryImpl: RegisterRepository {
    private let provider: MoyaProvider<InTechsAPI>
    private let loginRepository = LoginRepositoryImpl()
    
    public init(provider: MoyaProvider<InTechsAPI> = MoyaProvider<InTechsAPI>()) {
        self.provider = provider
    }
    
#if os(iOS)
    public func registerAsync(name: String, email: String, password: String) async -> AnyPublisher<Void, NetworkError> {
        provider.requestVoidPublisher(.register(name: name, email: email, password: password))
            .mapError {  NetworkError($0) }
            .map { _ in
                async {
                    await self.loginRepository.loginAsync(email: email, password: password)
                }
            }
            .mapError {  NetworkError($0) }
            .eraseToAnyPublisher()
    }
#endif
    
    @UserDefault(key: "accessToken", defaultValue: "")
    private var accessToken: String
    
    @UserDefault(key: "refreshToken", defaultValue: "")
    private var refreshToken: String
    
    public func register(name: String, email: String, password: String) -> AnyPublisher<Void, NetworkError> {
        provider.requestVoidPublisher(.register(name: name, email: email, password: password))
            .mapError {  NetworkError($0) }
            .flatMap { _ in
                self.loginRepository.login(email: email, password: password)
            }
            .mapError {  NetworkError($0) }
            .eraseToAnyPublisher()
    }
}
