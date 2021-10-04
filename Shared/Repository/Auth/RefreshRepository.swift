//
//  RefreshRepository.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/10/04.
//

import Foundation
import Moya

public protocol RefreshRepository {
    func refresh()
    func login()
}

final public class RefreshRepositoryImpl: RefreshRepository {
    private let provider: MoyaProvider<InTechsAPI>
    
    @UserDefault(key: "accessToken", defaultValue: "")
    var accessToken: String
    
    @UserDefault(key: "refreshToken", defaultValue: "")
    var refreshToken: String
    
    public init(provider: MoyaProvider<InTechsAPI> = MoyaProvider<InTechsAPI>()) {
        self.provider = provider
    }
    
    public func refresh() {
        provider.request(.refresh(refreshToken: ""), completion: { result in
            switch result {
            case .success(let response):
                let data = try! JSONDecoder().decode(RefreshReponse.self, from: response.data)
                self.accessToken = data.accessToken
            case .failure(let error):
                if NetworkError(error) == .unauthorized { // 리프레시 토큰 만료 시
                    self.login()
                }
            }
        })
    }
    
    public func login() {
        provider.request(.login(email: "", password: ""), completion: { result in
            switch result {
            case .success(let response):
                let data = try! JSONDecoder().decode(LoginReponse.self, from: response.data)
                self.accessToken = data.accessToken
                self.refreshToken = data.refreshToken
                
            case .failure(_):
                self.login() // 재시도 1번
            }
        })
    }
}
