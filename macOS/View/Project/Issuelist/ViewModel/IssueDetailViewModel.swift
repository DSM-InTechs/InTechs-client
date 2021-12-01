//
//  IssueDetailViewModel.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/10/25.
//

import Combine
import Moya
import Foundation

class IssueDetailViewModel: ObservableObject {
    private var preIssue: Issue? = nil
    
    @Published var title: String = ""
    @Published var isBody: Bool = false
    @Published var body: String = ""
    
    @Published var isDate: Bool = false
    @Published var date: Date = Date()
    @Published var isProgress: Bool = false
    @Published var progress: Float = 0.0
    @Published var state: IssueState?
    
    @Published var isUser: Bool = false
    @Published var users: [SelectIssueUser] = []
    
    @Published var isTag: Bool = false
    @Published var newTag: String = ""
    @Published var tags: [SelectIssueTag] = []
    
    @Published var newComment: String = ""
    
    private let issueReporitory: IssueReporitory
    private let dateFormatter = DateFormatter()
    
    private var bag = Set<AnyCancellable>()
    
    public enum Event {
        case change(id: String)
        case delete(id: String)
        case addComment(id: String)
    }
    
    public struct Input {
        let change = PassthroughSubject<String, Never>()
        let delete = PassthroughSubject<String, Never>()
        let addComment = PassthroughSubject<String, Never>()
    }
    
    public let input = Input()
    
    public func apply(_ input: Event) {
        switch input {
        case .change(let id):
            self.input.change.send(id)
        case .delete(let id):
            self.input.delete.send(id)
        case .addComment(let id):
            self.input.addComment.send(id)
        }
    }
    
    init(issueReporitory: IssueReporitory = IssueReporitoryImpl()) {
        self.issueReporitory = issueReporitory
        self.dateFormatter.dateFormat = "yyyy-MM-dd"
        
        input.change
            .flatMap {
                self.issueReporitory.modifyIssue(id: $0,
                                                 title: self.title,
                                                 body: self.isBody ? self.body : nil,
                                                 date: self.isDate ? self.dateFormatter.string(from: self.date) : nil,
                                                 progress: self.isProgress ? Int(self.progress) : nil,
                                                 state: self.state?.rawValue,
                                                 users: self.users.filter { $0.isSelected }.isEmpty ? nil : self.users.filter { $0.isSelected }.map { $0.email },
                                                 tags: self.tags.filter { $0.isSelected }.isEmpty ? nil : self.tags.filter { $0.isSelected }.map { $0.tag })
                    .catch { _ -> Empty<Void, Never> in
                        return .init()
                    }
            }
            .sink(receiveValue: { _ in })
            .store(in: &bag)
        
        input.delete
            .flatMap {
                self.issueReporitory.deleteIssue(id: $0)
                    .catch { _ -> Empty<Void, Never> in
                        return .init()
                    }
            }
            .sink(receiveValue: { _ in })
            .store(in: &bag)
        
        input.addComment
            .flatMap {
                self.issueReporitory.addComment(id: $0, content: self.newComment)
                    .catch { _ -> Empty<Void, Never> in
                        return .init()
                    }
            }
            .sink(receiveValue: { _ in
                self.newComment = ""
            })
            .store(in: &bag)
    }
    
    public func reload(_ input: Event) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.apply(input)
        })
    }
    
    public func setForUpdate(issue: Issue?) {
        if issue == nil { return }
        if preIssue == issue { return }
        
        self.title = issue!.title
        
        if issue!.content != nil {
            self.isBody = true
            self.body = issue!.content!
        }
        if issue!.endDate != nil {
            self.isDate = true
            self.date = dateFormatter.date(from: issue!.endDate!)!
        }
        if issue!.state != nil {
            self.state = state
        }
        if issue!.progress != nil {
            self.isProgress = true
            self.progress = Float(issue!.progress!)
        }
        if issue!.users != [] {
            self.isUser = true
            self.users = issue!.users.map { SelectIssueUser(user: $0, isSelected: true) }
        }
        if issue!.tags != [] {
            self.isTag = true
            self.tags = issue!.tags.map { SelectIssueTag(tag: $0, isSelected: true) }
        }
        
        self.preIssue = issue
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
