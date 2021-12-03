//
//  IssuelistViewModel.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/10/07.
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
    @Published var dashboard: ProjectDashboard = ProjectDashboard(userCount: 0, issuesCount: DashboardIssueCount(forMe: 0, resolved: 0, unresolved: 0, forMeAndUnresolved: 0))
    
    @Published var users = [SelectIssueUser]()
    @Published var tags = [SelectIssueTag]()
    @Published var state: IssueState?
    
    @UserDefault(key: "userEmail", defaultValue: "")
    private var userEmail: String
    
    private let issueReporitory: IssueReporitory
    private let projectRepository: ProjectRepository
    
    private var bag = Set<AnyCancellable>()
    
    public enum Event {
        case onAppear
        case reloadlist
        case getUnresolved
        case getForMe
        case getForMeAndUnresolved
    }
    
    public struct Input {
        let onAppear = PassthroughSubject<Void, Never>()
        let getFilteringList = PassthroughSubject<Void, Never>()
        let reloadlist = PassthroughSubject<Void, Never>()
        let getUnresolved = PassthroughSubject<Void, Never>()
        let getForMe = PassthroughSubject<Void, Never>()
        let getForMeAndUnresolved = PassthroughSubject<Void, Never>()
    }
    
    public let input = Input()
    
    public func apply(_ input: Event) {
        switch input {
        case .onAppear:
            self.input.onAppear.send(())
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5, execute: {
                self.input.getFilteringList.send(())
            })
        case .reloadlist:
            self.input.reloadlist.send(())
        case .getUnresolved:
            self.input.getUnresolved.send(())
        case .getForMe:
            self.input.getForMe.send(())
        case .getForMeAndUnresolved:
            self.input.getForMeAndUnresolved.send(())
        }
    }
    
    init(issueReporitory: IssueReporitory = IssueReporitoryImpl(),
         projectRepository: ProjectRepository = ProjectRepositoryImpl()) {
        self.issueReporitory = issueReporitory
        self.projectRepository = projectRepository
        
        self.$selectedTab
            .sink(receiveValue: { tab in
                switch tab {
                case .forMeAndUnresolved, .unresolved:
                    self.state = .progress
                case .resolved:
                    self.state = .done
                case .none:
                    self.state = nil
                default: break
                }
            }).store(in: &bag)
        
        input.onAppear
            .flatMap {
                self.issueReporitory.getIssues()
                    .catch { _ -> Empty<[Issue], Never> in
                        return .init()
                    }
            }
            .assign(to: \.issues, on: self)
            .store(in: &bag)
        
        input.onAppear
            .flatMap {
                self.projectRepository.getProjectDashBoard()
                    .catch { _ -> Empty<ProjectDashboard, Never> in
                        return .init()
                    }
            }
            .assign(to: \.dashboard, on: self)
            .store(in: &bag)
        
        input.getFilteringList
            .flatMap {
                self.issueReporitory.getUserlist()
                    .catch { _ -> Empty<[IssueUser], Never> in
                        return .init()
                    }
            }
            .map { $0.map { return SelectIssueUser(user: $0) } }
            .assign(to: \.users, on: self)
            .store(in: &bag)
        
        input.getFilteringList
            .flatMap {
                self.issueReporitory.getTaglist()
                    .catch { _ -> Empty<[IssueTag], Never> in
                        return .init()
                    }
            }
            .map { $0.map { return SelectIssueTag(tag: $0) } }
            .assign(to: \.tags, on: self)
            .store(in: &bag)
        
        input.reloadlist
            .collect(.byTime(DispatchQueue.main, .seconds(1)))
            .flatMap { _ in
                self.issueReporitory.getIssues(tags: self.tags.filter { $0.isSelected == true }.map { $0.tag },
                                               users: self.users.filter { $0.isSelected == true }.map { $0.email },
                                               states: (self.state != nil) ? [self.state!.rawValue] : nil)
                    .catch { _ -> Empty<[Issue], Never> in
                        return .init()
                    }
            }
            .assign(to: \.issues, on: self)
            .store(in: &bag)
        
        input.getUnresolved
            .collect(.byTime(DispatchQueue.main, .seconds(1)))
            .flatMap { _ in
                self.issueReporitory.getIssues(tags: self.tags.filter { $0.isSelected == true }.map { $0.tag },
                                               users: self.users.filter { $0.isSelected == true }.map { $0.email },
                                               states: [IssueState.ready.rawValue,
                                                        IssueState.progress.rawValue,])
                    .catch { _ -> Empty<[Issue], Never> in
                        return .init()
                    }
            }
            .assign(to: \.issues, on: self)
            .store(in: &bag)
        
        input.getForMe
            .collect(.byTime(DispatchQueue.main, .seconds(1)))
            .flatMap { _ in
                self.issueReporitory.getIssues(tags: self.tags.filter { $0.isSelected == true }.map { $0.tag },
                                               users: [self.userEmail],
                                               states: (self.state != nil) ? [self.state!.rawValue] : nil)
                    .catch { _ -> Empty<[Issue], Never> in
                        return .init()
                    }
            }
            .assign(to: \.issues, on: self)
            .store(in: &bag)
        
        input.getForMeAndUnresolved
            .collect(.byTime(DispatchQueue.main, .seconds(1)))
            .flatMap { _ in
                self.issueReporitory.getIssues(tags: self.tags.filter { $0.isSelected == true }.map { $0.tag },
                                               users: [self.userEmail],
                                               states: [IssueState.ready.rawValue,
                                                        IssueState.progress.rawValue])
                    .catch { _ -> Empty<[Issue], Never> in
                        return .init()
                    }
            }
            .assign(to: \.issues, on: self)
            .store(in: &bag)
    }
    
    public func changeSelectedTab(_ tab: IssueTab) {
        if self.selectedTab == tab {
            self.selectedTab = nil
            self.state = nil
            self.apply(.reloadlist)
            return
        }
        
        switch tab {
        case .resolved:
            self.selectedTab = .resolved
            self.state = IssueState.done
            self.apply(.reloadlist)
        case .forMe:
            self.selectedTab = .forMe
            self.apply(.getForMe)
        case .forMeAndUnresolved:
            self.selectedTab = .forMeAndUnresolved
            self.apply(.getForMeAndUnresolved)
        case .unresolved:
            self.selectedTab = .unresolved
            self.apply(.getUnresolved)
        }
    }
    
    public func reload(_ input: Event) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.apply(input)
        })
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
