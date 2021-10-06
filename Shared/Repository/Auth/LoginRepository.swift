//
//  LoginRepository.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/10/04.
//

import Moya
import Combine

public protocol LoginRepository {
    #if os(iOS)
    func loginAsync(email: String, password: String) async -> AnyPublisher<Void, NetworkError>
    #endif
    func login(email: String, password: String) -> AnyPublisher<Void, NetworkError>
}

final public class LoginRepositoryImpl: LoginRepository {
    private let provider: MoyaProvider<InTechsAPI>
    
    @UserDefault(key: "accessToken", defaultValue: "")
    var accessToken: String
    
    @UserDefault(key: "refreshToken", defaultValue: "")
    var refreshToken: String
    
    public init(provider: MoyaProvider<InTechsAPI> = MoyaProvider<InTechsAPI>()) {
        self.provider = provider
    }
    
    #if os(iOS)
    public func loginAsync(email: String, password: String) async -> AnyPublisher<Void, NetworkError> {
        provider.requestPublisher(.login(email: email, password: password))
            .map(LoginReponse.self)
            .map { response in
                self.accessToken = response.accessToken
                self.refreshToken = response.refreshToken
                return
            }
            .mapError {  NetworkError($0) }
            .eraseToAnyPublisher()
    }
    #endif
    
    public func login(email: String, password: String) -> AnyPublisher<Void, NetworkError> {
        provider.requestPublisher(.login(email: email, password: password))
            .map(LoginReponse.self)
            .map { response in
                self.accessToken = response.accessToken
                self.refreshToken = response.refreshToken
                return
            }
            .mapError {  NetworkError($0) }
            .eraseToAnyPublisher()
    }
}
