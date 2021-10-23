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
    case channelRename
    case channelDelete
    case channelCreate
    case messageDelete
    case issueDelete(execute: () -> Void)
    case issueCreate
    case projectCreate
    case projectJoin
    case projectExit(execute: () -> Void)
    case projectDelete(execute: () -> Void)
}

class HomeViewModel: ObservableObject {
    @Published var isLogin: Bool = true
    
    @Published var selectedTab: HomeTab = HomeTab.chats
    @Published var toast: Toast?
    
    @Published var selectedRecentMsg: String? = recentMsgs.first?.id
    @Published var msgs: [RecentMessage] = recentMsgs
    
    @Published var message = ""
    
    func sendMessage(user: RecentMessage) {
        let index = msgs.firstIndex { currentUser -> Bool in
            return currentUser.id == user.id
        } ?? -1
        if index != -1 {
            msgs[index].allMsgs.append(Message(message: message, myMessage: true))
            message = ""
        }
    }
    
    @UserDefault(key: "currentProject", defaultValue: 0)
    public var currentProject: Int
    
    @Published var profile: Mypage = Mypage(name: "", email: "", image: "")
    @Published var myProjects: [Project] = [Project]()
    
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
