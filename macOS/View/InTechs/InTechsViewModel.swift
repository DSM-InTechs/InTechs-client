//
//  InTechsViewModel.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/30.
//

import SwiftUI
import Combine

class InTechsViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    
    @Published var success: Bool = false
    @Published var errorMessage: String = ""
    @Published var attempts: Int = 1
    
    private let loginRepository: LoginRepository
    private let registerRepository: RegisterRepository
    private var bag = Set<AnyCancellable>()
    
    public enum Event {
        case login
        case register
    }
    
    public struct Input {
        let loginTapped = PassthroughSubject<Void, Never>()
        let registerTapped = PassthroughSubject<Void, Never>()
    }
    
    public let input = Input()
    
    public func apply(_ input: Event) {
        switch input {
        case .login:
            self.input.loginTapped.send(())
        case .register:
            self.input.registerTapped.send(())
        }
    }
    
    init(loginRepository: LoginRepository = LoginRepositoryImpl(),
         registerRepository: RegisterRepository = RegisterRepositoryImpl()) {
        self.loginRepository = loginRepository
        self.registerRepository = registerRepository
        
        input.loginTapped
            .flatMap { _ in
                self.loginRepository.login(email: self.email, password: self.password)
                    .catch { [weak self] err -> Empty<Void, Never> in
                        guard let self = self else { return .init() }
                        self.errorMessage = self.getErrorMessage(error: err)
                        return .init()
                    }
            }.sink(receiveValue: { [weak self] _ in
                self?.email = ""
                self?.password = ""
                self?.success = true
            })
            .store(in: &bag)
        
        input.registerTapped
            .flatMap { _ in
                self.registerRepository.register(name: self.name, email: self.email, password: self.password)
                    .catch { [weak self] err -> Empty<Void, Never> in
                        guard let self = self else { return .init() }
                        self.errorMessage = self.getErrorMessage(error: err)
                        return .init()
                    }
            }.sink(receiveValue: { [weak self] _ in
                self?.email = ""
                self?.password = ""
                self?.success = true
            })
            .store(in: &bag)
    }
    
    private func getErrorMessage(error: NetworkError) -> String {
        switch error {
        case .unauthorized:
            return ""
        default:
            return error.message
        }
    }
}
