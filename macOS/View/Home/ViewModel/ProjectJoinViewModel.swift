//
//  ProjectJoinViewModel.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/10/08.
//

import SwiftUI
import Combine

class ProjectJoinViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var image: NSImage?
    
    private let projectRepository: ProjectRepository
    
    private var bag = Set<AnyCancellable>()
    
    public enum Event {
        case joinProject(number: String)
    }
    
    public struct Input {
        let joinProject = PassthroughSubject<Int, Never>()
    }
    
    public let input = Input()
    
    public func apply(_ input: Event) {
        switch input {
        case .joinProject(let number):
            if Int(number) == nil {
                // ERROR
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
                        return .init()
                    }
            }
            .sink(receiveValue: { _ in })
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
