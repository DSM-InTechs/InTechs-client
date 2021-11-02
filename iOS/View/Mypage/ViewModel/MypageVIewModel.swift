//
//  MypageVIewModel.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/29.
//

import SwiftUI
import Combine

class MypageViewModel: ObservableObject {
    @Published var profile: Mypage = Mypage(name: "", email: "", image: "")
    @Published var myProjects: [Project] = [Project]()
    @Published var projectName: String = ""
    
    @UserDefault(key: "currentProject", defaultValue: 0)
    public var currentProject: Int
    
    @Published var originalImage: UIImage?
    @Published var updatedName: String = ""
    @Published var updatedImage: UIImage?
    
    public var successExecute: () -> Void = {}
    
    private let mypageRepository: MypageRepository
    private let projectRepository: ProjectRepository
    
    private var bag = Set<AnyCancellable>()
    
    public enum Event {
        case mypage
        case getProjects
        case change
        case deleteUser
    }
    
    public struct Input {
        let mypage = PassthroughSubject<Void, Never>()
        let getProjects = PassthroughSubject<Void, Never>()
        let change = PassthroughSubject<Void, Never>()
        let deleteUser = PassthroughSubject<Void, Never>()
    }
    
    public let input = Input()
    
    public func apply(_ input: Event) {
        switch input {
        case .mypage:
            self.input.mypage.send(())
        case .getProjects:
            self.input.getProjects.send(())
        case .change:
            self.input.change.send(())
        case .deleteUser:
            self.input.deleteUser.send(())
        }
    }
    
    init(mypageRepository: MypageRepository = MypageRepositoryImpl(),
         projectRepository: ProjectRepository = ProjectRepositoryImpl()) {
        self.mypageRepository = mypageRepository
        self.projectRepository = projectRepository
        
        input.mypage
            .flatMap {
                self.mypageRepository.mypage()
                    .catch { _ -> Empty<Mypage, Never> in
                        return .init()
                    }
            }
            .sink(receiveValue: { profile in
                self.profile = profile
                self.updatedName = profile.name
                let data = try? Data(contentsOf: URL(string: self.profile.image)!)
                self.originalImage = UIImage(data: data!) ?? UIImage(asset: Asset.placeholder)
            })
            .store(in: &bag)
        
        input.mypage
            .flatMap {
                self.projectRepository.myProjects()
                    .catch { _ -> Empty<[Project], Never> in
                        return .init()
                    }
            }
            .sink(receiveValue: { projects in
                for project in projects {
                    if self.currentProject == project.id {
                        self.projectName = project.name
                    }
                }
            })
            .store(in: &bag)
        
        input.getProjects
            .flatMap {
                self.projectRepository.myProjects()
                    .catch { _ -> Empty<[Project], Never> in
                        return .init()
                    }
            }
            .assign(to: \.myProjects, on: self)
            .store(in: &bag)
        
        input.change
            .flatMap {
                self.mypageRepository.updateMypage(name: self.updatedName,
                                                     image: self.updatedImage ?? self.originalImage!)
                    .catch { _ -> Empty<Void, Never> in
                        return .init()
                    }
            }
            .sink(receiveValue: { [self] _ in
                self.profile.name = self.updatedName
                if self.updatedImage != nil {
                    self.originalImage = self.updatedImage
                }
            })
            .store(in: &bag)
        
        input.deleteUser
            .flatMap {
                self.mypageRepository.deleteUser()
                    .catch { _ -> Empty<Void, Never> in
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
