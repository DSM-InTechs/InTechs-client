//
//  RegisterRepository.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/10/04.
//

import Moya
import Combine

public protocol RegisterRepository {
    func registerAsync(name: String, email: String, password: String) async -> AnyPublisher<Void, NetworkError>
    func register(name: String, email: String, password: String) -> AnyPublisher<Void, NetworkError>
}

final public class RegisterRepositoryImpl: RegisterRepository {
    private let provider: MoyaProvider<InTechsAPI>
    private let loginRepository = LoginRepositoryImpl()
    
    public init(provider: MoyaProvider<InTechsAPI>?) {
        self.provider = provider ??  MoyaProvider<InTechsAPI>()
    }
    
    public func registerAsync(name: String, email: String, password: String) async -> AnyPublisher<Void, NetworkError> {
        provider.requestVoidPublisher(.register(name: name, email: email, password: password))
            .mapError {  NetworkError($0) }
            .map { _ in
                #if os(iOS)
                async {
                    await self.loginRepository.login(email: email, password: password)
                }
                #endif
            }
            .mapError {  NetworkError($0) }
            .eraseToAnyPublisher()
    }
    
    @UserDefault(key: "accessToken", defaultValue: "")
    var accessToken: String
    
    @UserDefault(key: "refreshToken", defaultValue: "")
    var refreshToken: String
    
    public func register(name: String, email: String, password: String) -> AnyPublisher<Void, NetworkError> {
        var success = false
        var error: NetworkError? = nil
        
        provider.request(.register(name: name, email: email, password: password), completion: { result in
            switch result {
            case .success(_):
                self.provider.request(.login(email: "", password: ""), completion: { result in
                    switch result {
                    case .success(let response):
                        let data = try! JSONDecoder().decode(LoginReponse.self, from: response.data)
                        self.accessToken = data.accessToken
                        self.refreshToken = data.refreshToken
                        success = true
                    case .failure(let err):
                        error = NetworkError(err)
                    }
                })
            case .failure(let err):
                error = NetworkError(err)
            }
        })
        
        if success {
            return Just(())
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: error!).eraseToAnyPublisher()
        }
    }
}
