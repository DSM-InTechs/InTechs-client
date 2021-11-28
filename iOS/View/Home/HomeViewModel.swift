//
//  HomeViewModel.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/29.
//

import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @UserDefault(key: "isLogin", defaultValue: false)
    public var isLoginUserDefaults: Bool
    
    @Published var isLogin: Bool = UserDefaults.standard.bool(forKey: "isLogin")
    
    private let myActiveRepository: MyActiveRepository
    private let mypageRepository: MypageRepository
    private var bag = Set<AnyCancellable>()
    
    public enum Event {
        case changeActive(isActive: Bool)
    }
    
    public struct Input {
        let changeActive = PassthroughSubject<Bool, Never>()
    }
    
    public let input = Input()
    
    public func apply(_ input: Event) {
        switch input {
        case .changeActive(let isActive):
            self.input.changeActive.send(isActive)
        }
    }
    
    init(myActiveRepository: MyActiveRepository = MyActiveRepositoryImpl(),
         mypageRepository: MypageRepository = MypageRepositoryImpl()) {
        self.myActiveRepository = myActiveRepository
        self.mypageRepository = mypageRepository
        
        self.$isLogin
            .dropFirst()
            .sink(receiveValue: {
                self.isLoginUserDefaults = $0
            }).store(in: &bag)
        
        input.changeActive
            .flatMap {
                self.myActiveRepository.updateMyActive(isActive: $0)
                    .catch { _ -> Empty<Void, Never> in
                        return .init()
                    }
            }
            .sink(receiveValue: { _ in })
            .store(in: &bag)
        
    }
    
    public func logout() {
        self.mypageRepository.logout()
        self.isLogin = false
    }
    
    private func getErrorMessage(error: NetworkError) -> String {
        switch error {
        case .notFound:
            return "유저를 찾을 수 없습니다."
        case .unauthorized:
            return "토큰이 만료되었습니다."
        default:
            return error.message
        }
    }
}
