//
//  HomeViewModel.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/29.
//

import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @Published var isLogin: Bool = true
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    
    private let myActiveRepository: MyActiveRepository
    private var bag = Set<AnyCancellable>()
    
    public var successExecute: () -> Void = {}
    
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
    
    init(myActiveRepository: MyActiveRepository = MyActiveRepositoryImpl()) {
        self.myActiveRepository = myActiveRepository
        
        input.changeActive
            .flatMap {
                self.myActiveRepository.updateMyActive(isActive: $0)
                    .catch { err -> Empty<Void, Never> in
                        withAnimation {
                            self.errorMessage = self.getErrorMessage(error: err)
                        }
                        
                        return .init()
                    }
            }
            .sink(receiveValue: { _ in print("SUCCESS") })
            .store(in: &bag)
        
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
