//
//  ProjectJoinViewModel.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/10/08.
//

import SwiftUI
import Combine

class ProjectJoinViewModel: ObservableObject {
    @Published var number: String = ""
    @Published var attempts: Int = 0
    
    public var successExecute: () -> Void = {}
    
    private let projectRepository: ProjectRepository
    
    private var bag = Set<AnyCancellable>()
    
    public enum Event {
        case joinProject
    }
    
    public struct Input {
        let joinProject = PassthroughSubject<Int, Never>()
    }
    
    public let input = Input()
    
    public func apply(_ input: Event) {
        switch input {
        case .joinProject:
            if Int(number) == nil {
                // ERROR
                self.attempts += 1
            } else {
                self.input.joinProject.send(Int(number)!)
            }
        }
    }
    
    init(projectRepository: ProjectRepository = ProjectRepositoryImpl()) {
        self.projectRepository = projectRepository
        
        input.joinProject
            .flatMap {
                self.projectRepository.joinProject(number: $0)
                    .catch { _ -> Empty<Void, Never> in
                        self.attempts += 1
                        return .init()
                    }
            }
            .sink(receiveValue: { _ in
                self.successExecute()
            })
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
