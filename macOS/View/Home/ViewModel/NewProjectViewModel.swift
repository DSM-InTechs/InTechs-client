//
//  NewProjectViewModel.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/10/08.
//

import SwiftUI
import Combine

class NewProjectViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var image: NSImage?
    
    private let projectRepository: ProjectRepository
    
    private var bag = Set<AnyCancellable>()
    
    public enum Event {
        case createProject
    }
    
    public struct Input {
        let createProject = PassthroughSubject<Void, Never>()
    }
    
    public let input = Input()
    
    public func apply(_ input: Event) {
        switch input {
        case .createProject:
            self.input.createProject.send(())
        }
    }
    
    init(projectRepository: ProjectRepository = ProjectRepositoryImpl()) {
        self.projectRepository = projectRepository
        
        input.createProject
            .flatMap {
                self.projectRepository.createProject(name: self.name,
                                                     image: self.image ?? Asset.placeholder.image)
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
