//
//  HomeViewModel.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/22.
//

import SwiftUI
import Combine

enum Toast {
    case userDelete(execute: () -> Void)
    case channelSearch
    case channelInfo
    case channelRename(channel: RoomInfo, execute: () -> Void)
    case channelExit(channel: RoomInfo, execute: () -> Void)
    case channelDelete(channel: RoomInfo, execute: () -> Void)
    case channelCreate(execute: () -> Void)
    case messageDelete(execute: () -> Void)
    case issueDelete(execute: () -> Void)
    case issueCreate(execute: () -> Void)
    case projectCreateOrJoin
    case projectCreate
    case projectJoin
    case projectExit(execute: () -> Void)
    case projectDelete(execute: () -> Void)
}

class HomeViewModel: ObservableObject {
    @UserDefault(key: "isLogin", defaultValue: false)
    private var isLoginUserDefaults: Bool
    
    @Published var isLogin: Bool = UserDefaults.standard.bool(forKey: "isLogin")
    
    @Published var selectedTab: HomeTab = HomeTab.chats
    @Published var toast: Toast?
    
    @UserDefault(key: "currentProject", defaultValue: 0)
    public var currentProjectUserDefaults: Int
    
    @Published var currentProject: Int = UserDefaults.standard.integer(forKey: "currentProject")
    
    @Published var profile: Mypage = Mypage(name: "", email: "", image: "")
    @Published var myProjects: [Project] = [Project]()
    
    private let center = NotificationCenter.default
    
    private let myActiveRepository: MyActiveRepository
    private let projectRepository: ProjectRepository
    private let mypageRepository: MypageRepository
    
    private var bag = Set<AnyCancellable>()
    
    public enum Event {
        case changeActive(isActive: Bool)
        case onAppear
    }
    
    public struct Input {
        let changeActive = PassthroughSubject<Bool, Never>()
        let onAppear = PassthroughSubject<Void, Never>()
    }
    
    public let input = Input()
    
    public func changeCurrentProject(projectId: Int) {
        self.currentProject = projectId
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5, execute: {
            self.center.post(name: Notification.Name("Home"), object: nil)
        })
    }
    
    public func apply(_ input: Event) {
        switch input {
        case .changeActive(let isActive):
            self.input.changeActive.send(isActive)
        case .onAppear:
            self.input.onAppear.send(())
        }
    }
    
    init(myActiveRepository: MyActiveRepository = MyActiveRepositoryImpl(),
         projectRepository: ProjectRepository = ProjectRepositoryImpl(),
         mypageRepository: MypageRepository = MypageRepositoryImpl()) {
        self.myActiveRepository = myActiveRepository
        self.projectRepository = projectRepository
        self.mypageRepository = mypageRepository
        
        self.$isLogin
            .dropFirst()
            .sink(receiveValue: {
                self.isLoginUserDefaults = $0
            }).store(in: &bag)
        
        self.$currentProject
            .dropFirst()
            .sink(receiveValue: {
                self.currentProjectUserDefaults = $0
            }).store(in: &bag)
        
        input.changeActive
            .flatMap {
                self.myActiveRepository.updateMyActive(isActive: $0)
                    .catch { _ -> Empty<Void, Never> in
                        return .init()
                    }
            }
            .sink(receiveValue: { _ in })
            .store(in: &bag)
        
        input.onAppear
            .flatMap {
                self.mypageRepository.mypage()
                    .catch { _ -> Empty<Mypage, Never> in
                        return .init()
                    }
            }
            .assign(to: \.profile, on: self)
            .store(in: &bag)
        
        input.onAppear
            .flatMap {
                self.projectRepository.myProjects()
                    .catch { _ -> Empty<[Project], Never> in
                        return .init()
                    }
            }
            .assign(to: \.myProjects, on: self)
            .store(in: &bag)
        
    }
    
    public func logout() {
        self.mypageRepository.logout()
        self.isLogin = false
        self.myProjects = []
        self.profile = Mypage(name: "", email: "", image: "")
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
