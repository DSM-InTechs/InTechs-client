//
//  SettingViewModel.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/10/07.
//

import Combine
import Moya

class SettingViewModel: ObservableObject {
    @Published public var projectInfo: ProjectInfo = ProjectInfo(name: "", image: ProjectInfoImage(imageUrl: "", oriName: ""))
    @UserDefault(key: "currentProject", defaultValue: 0)
    public var currentProject: Int
    
    @Published var originalImage: NSImage?
    @Published var updatedName: String = ""
    @Published var updatedImage: NSImage?
    
    private let projectRepository: ProjectRepository
    
    private var bag = Set<AnyCancellable>()
    
    public enum Event {
        case onAppear
        case change
        case delete
    }
    
    public struct Input {
        let onAppear = PassthroughSubject<Void, Never>()
        let change = PassthroughSubject<Void, Never>()
        let delete = PassthroughSubject<Void, Never>()
    }
    
    public let input = Input()
    
    public func apply(_ input: Event) {
        switch input {
        case .onAppear:
            self.input.onAppear.send(())
        case .change:
            if self.updatedName != projectInfo.name || self.updatedImage != originalImage { // 변경 사항이 하나라도 있다면
                self.input.change.send(())
            }
        case .delete:
            self.input.delete.send(())
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
            .sink(receiveValue: { info in
                self.projectInfo = info
                self.updatedName = info.name
                self.originalImage = NSImage(byReferencing: URL(string: self.projectInfo.image.imageUrl)!)
            })
            .store(in: &bag)
        
        input.change
            .flatMap {
                self.projectRepository.updateProject(name: self.updatedName,
                                                     image: self.updatedImage ?? self.originalImage!)
                    .catch { _ -> Empty<Void, Never> in
                        return .init()
                    }
            }
            .sink(receiveValue: { [self] _ in
                self.projectInfo.name = self.updatedName
                if self.updatedImage != nil {
                    self.originalImage = self.updatedImage
                }
            })
            .store(in: &bag)
        
        input.delete
            .flatMap {
                self.projectRepository.deleteProject()
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
