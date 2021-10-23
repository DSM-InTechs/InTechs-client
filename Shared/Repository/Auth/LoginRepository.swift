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
    private var accessToken: String
    
    @UserDefault(key: "refreshToken", defaultValue: "")
    private var refreshToken: String
    
    @UserDefault(key: "userEmail", defaultValue: "")
    private var userEmail: String
    
    @UserDefault(key: "userPassword", defaultValue: "")
    private var userPassword: String
    
    public init(provider: MoyaProvider<InTechsAPI> = MoyaProvider<InTechsAPI>()) {
        self.provider = provider
    }
    
    #if os(iOS)
    public func loginAsync(email: String, password: String) async -> AnyPublisher<Void, NetworkError> {
        provider.requestPublisher(.login(email: email, password: password))
            .map(AuthReponse.self)
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
            .map(AuthReponse.self)
            .map { response in
                self.accessToken = response.accessToken
                self.refreshToken = response.refreshToken
                self.userEmail = email
                self.userPassword = password
                return
            }
            .mapError {  NetworkError($0) }
            .eraseToAnyPublisher()
    }
}
