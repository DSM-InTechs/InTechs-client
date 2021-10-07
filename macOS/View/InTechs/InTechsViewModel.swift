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
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    
    private let loginRepository: LoginRepository
    private let registerRepository: RegisterRepository
    private var bag = Set<AnyCancellable>()
    
    public var successExecute: () -> Void = {}
    
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
            .map {  self.changeLoading(isLoading: true) }
            .flatMap { _ in
                self.loginRepository.login(email: self.email, password: self.password)
                    .catch { err -> Empty<Void, Never> in
                        self.changeLoading(isLoading: false)
                        withAnimation {
                            self.errorMessage = self.getErrorMessage(error: err)
                        }
                        
                        return .init()
                    }
            }.sink(receiveValue: { [weak self] _ in
                self?.changeLoading(isLoading: false)
                self?.successExecute()
            })
            .store(in: &bag)
        
        input.registerTapped
            .flatMap { _ in
                self.registerRepository.register(name: self.name, email: self.email, password: self.password)
                    .catch { err -> Empty<Void, Never> in
                        self.changeLoading(isLoading: false)
                        withAnimation {
                            self.errorMessage = self.getErrorMessage(error: err)
                        }
                        
                        return .init()
                    }
            }.sink(receiveValue: { [weak self] _ in
                self?.changeLoading(isLoading: false)
                self?.successExecute()
            })
            .store(in: &bag)
    }
    
    private func getErrorMessage(error: NetworkError) -> String {
        switch error {
        case .notFound:
            return "유저를 찾을 수 없습니다."
        case .conflict:
            return "이미 존재하는 이메일입니다."
        default:
            return error.message
        }
    }
    
    private func changeLoading(isLoading: Bool) {
        withAnimation {
            self.isLoading = isLoading
        }
    }
}
