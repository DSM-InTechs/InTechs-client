//
//  IssuelistViewModel.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/29.
//

import Combine
import Moya

enum IssueTab {
    case forMe
    case unresolved
    case forMeAndUnresolved
    case resolved
}

class IssuelistViewModel: ObservableObject {
    @Published var issues = [Issue]()
    @Published var selectedTab: IssueTab?
    
    @Published var state: [IssueState]?
    @Published var users: [String]?
    
    private let issueReporitory: IssueReporitory
    private let projectRepository: ProjectRepository
    
    @UserDefault(key: "userEmail", defaultValue: "")
    private var userEmail: String
    
    private var bag = Set<AnyCancellable>()
    
    public enum Event {
        case onAppear
        case reloadlist
    }
    
    public struct Input {
        let onAppear = PassthroughSubject<Void, Never>()
        let reloadlist = PassthroughSubject<Void, Never>()
    }
    
    public let input = Input()
    
    public func apply(_ input: Event) {
        switch input {
        case .onAppear:
            self.input.onAppear.send(())
        case .reloadlist:
            self.input.reloadlist.send(())
        }
    }
    
    init(issueReporitory: IssueReporitory = IssueReporitoryImpl(),
         projectRepository: ProjectRepository = ProjectRepositoryImpl()) {
        self.issueReporitory = issueReporitory
        self.projectRepository = projectRepository
        
        input.onAppear
            .flatMap {
                self.issueReporitory.getIssues()
                    .catch { _ -> Empty<[Issue], Never> in
                        return .init()
                    }
            }
            .assign(to: \.issues, on: self)
            .store(in: &bag)
        
        input.reloadlist
            .flatMap { _ in
                self.issueReporitory.getIssues(tags: nil,
                                               users: (self.users != nil) ? self.users : nil,
                                               states: (self.state != nil) ? self.state!.map { $0.rawValue } : nil)
                    .catch { _ -> Empty<[Issue], Never> in
                        return .init()
                    }
            }
            .assign(to: \.issues, on: self)
            .store(in: &bag)
        
    }
    
    public func reload(_ input: Event) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.apply(input)
        })
    }
    
    public func modifyState() {
        switch self.selectedTab {
        case .forMe:
            self.users = [self.userEmail]
            self.state = nil
        case .forMeAndUnresolved:
            self.users = [self.userEmail]
            self.state = [.progress, .ready]
        case .resolved:
            self.users = nil
            self.state = [.done]
        case .unresolved:
            self.users = nil
            self.state = [.progress, .ready]
        case .none:
            self.users = nil
            self.state = nil
        }
        self.apply(.reloadlist)
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
