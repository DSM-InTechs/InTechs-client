//
//  ProjectViewModel.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/08/22.
//

import SwiftUI
import Combine

class ProjectViewModel: ObservableObject {
    @Published var selectedTab: ProjectTab = .dashBoard
    @Published var projectInfo: ProjectInfo = ProjectInfo(name: "", image: ProjectInfoImage(imageUrl: "", oriName: ""))
    
    private let projectRepository: ProjectRepository
    
    private var bag = Set<AnyCancellable>()
    
    public enum Event {
        case onAppear
    }
    
    public struct Input {
        let onAppear = PassthroughSubject<Void, Never>()
    }
    
    public let input = Input()
    
    public func apply(_ input: Event) {
        switch input {
        case .onAppear:
            self.input.onAppear.send(())
        }
    }
    
    init(projectRepository: ProjectRepository = ProjectRepositoryImpl()) {
        self.projectRepository = projectRepository
        
        input.onAppear
            .flatMap {
                self.projectRepository.getProjectInfo()
                    .catch { _ -> Empty<ProjectInfo, Never> in
                        return .init()
                    }
            }
            .assign(to: \.projectInfo, on: self)
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
