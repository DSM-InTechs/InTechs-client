//
//  MemberViewModel.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/10/06.
//

import SwiftUI
import Combine

class MemberViewModel: ObservableObject {
    @Published var members: [User] = [User]()
    
    private let projectRepository: ProjectRepository
    
    private var bag = Set<AnyCancellable>()
    
    public enum Event {
        case onAppear
    }
    
    public struct Input {
        let getMembers = PassthroughSubject<Void, Never>()
    }
    
    public let input = Input()
    
    public func apply(_ input: Event) {
        switch input {
        case .onAppear:
            self.input.getMembers.send(())
        }
    }
    
    init(projectRepository: ProjectRepository = ProjectRepositoryImpl()) {
        self.projectRepository = projectRepository
        
        input.getMembers
            .flatMap {
                self.projectRepository.getProjectMembers()
                    .catch { _ -> Empty<[User], Never> in
                        return .init()
                    }
            }
            .assign(to: \.members, on: self)
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
