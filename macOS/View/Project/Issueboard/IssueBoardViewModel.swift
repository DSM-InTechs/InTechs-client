//
//  IssueBoardViewModel.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/10/07.
//

import Combine
import Moya

class IssueBoardViewModel: ObservableObject {
    @Published var allIssues = [[Issue]]()
    @Published var headers = ["Ready", "In Progress", "Done"]
    @Published var ready = [Issue]()
    @Published var progress = [Issue]()
    @Published var done = [Issue]()
    
    @Published var users = [SelectIssueUser]()
    @Published var tags = [SelectIssueTag]()
//    @Published var state: IssueState?
    
    private let issueReporitory: IssueReporitory
    
    private var bag = Set<AnyCancellable>()
    
    public enum Event {
        case onAppear
        case reloadlist
    }
    
    public struct Input {
        let onAppear = PassthroughSubject<Void, Never>()
        let getFilteringList = PassthroughSubject<Void, Never>()
        let reloadlist = PassthroughSubject<Void, Never>()
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
        }
    }
    
    init(issueReporitory: IssueReporitory = IssueReporitoryImpl()) {
        self.issueReporitory = issueReporitory
        
        input.onAppear
            .flatMap {
                self.issueReporitory.getIssues()
                    .catch { _ -> Empty<[Issue], Never> in
                        return .init()
                    }
            }
            .sink(receiveValue: { issues in
                self.ready = issues.filter { $0.state == IssueState.ready.rawValue }
                self.progress = issues.filter { $0.state == IssueState.progress.rawValue }
                self.done = issues.filter { $0.state == IssueState.done.rawValue }
                self.allIssues = [self.ready, self.progress, self.done]
            })
//            .assign(to: \.issues, on: self)
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
                                               states: nil)
                    .catch { _ -> Empty<[Issue], Never> in
                        return .init()
                    }
            }
            .sink(receiveValue: { issues in
                self.ready = issues.filter { $0.state == IssueState.ready.rawValue }
                self.progress = issues.filter { $0.state == IssueState.progress.rawValue }
                self.done = issues.filter { $0.state == IssueState.done.rawValue }
                self.allIssues = [self.ready, self.progress, self.done]
            })
//            .assign(to: \.issues, on: self)
            .store(in: &bag)
        
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
