//
//  DashboardViewModel.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/10/21.
//

import SwiftUI
import Combine

class DasboardViewModel: ObservableObject {
    @Published var dashboard: ProjectDashboard = ProjectDashboard(userCount: 0, issuesCount: DashboardIssueCount(forMe: 0, resolved: 0, unresolved: 0, forMeAndUnresolved: 0))
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
                self.projectRepository.getProjectDashBoard()
                    .catch { _ -> Empty<ProjectDashboard, Never> in
                        return .init()
                    }
            }
            .assign(to: \.dashboard, on: self)
            .store(in: &bag)
        
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
