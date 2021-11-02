//
//  MypageViewModel.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/10/13.
//

import SwiftUI
import Combine

class MypageViewModel: ObservableObject {
    @Published var profile: Mypage = Mypage(name: "", email: "", image: "")
    @Published var myProjects: [Project] = [Project]()
    
    @UserDefault(key: "currentProject", defaultValue: 0)
    public var currentProject: Int
    
    @Published var originalImage: NSImage?
    @Published var updatedName: String = ""
    @Published var updatedImage: NSImage?
    
    public var successExecute: () -> Void = {}
    
    private let mypageRepository: MypageRepository
    private let projectRepository: ProjectRepository
    
    private var bag = Set<AnyCancellable>()
    
    public enum Event {
        case mypage
        case change
        case deleteUser
    }
    
    public struct Input {
        let mypage = PassthroughSubject<Void, Never>()
        let change = PassthroughSubject<Void, Never>()
        let deleteUser = PassthroughSubject<Void, Never>()
    }
    
    public let input = Input()
    
    public func apply(_ input: Event) {
        switch input {
        case .mypage:
            self.input.mypage.send(())
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
                self.originalImage = NSImage(byReferencing: URL(string: self.profile.image)!)
            })
            .store(in: &bag)
        
        input.mypage
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
