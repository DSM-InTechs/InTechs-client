//
//  NewIssueViewModel.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/10/24.
//

import Combine
import Moya

public struct SelectIssueUser: Codable, Hashable, Equatable {
    public var name: String
    public var email: String
    public var imageURL: String
    public var isSelected: Bool
    
    init(user: IssueUser, isSelected: Bool = false) {
        self.name = user.name
        self.email = user.email
        self.imageURL = user.imageURL
        self.isSelected = isSelected
    }
}

public struct SelectIssueTag: Codable, Hashable, Equatable {
    public var tag: String
    public var isSelected: Bool
    
    init(tag: IssueTag, isSelected: Bool = false) {
        self.tag = tag.tag
        self.isSelected = isSelected
    }
}

class NewIssueViewModel: ObservableObject {
    @Published var issues = [Issue]()
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
    
    private let issueReporitory: IssueReporitory
    private let dateFormatter = DateFormatter()
    
    private var bag = Set<AnyCancellable>()
    
    public enum Event {
        case onAppear
        case create
    }
    
    public struct Input {
        let onAppear = PassthroughSubject<Void, Never>()
        let create = PassthroughSubject<Void, Never>()
    }
    
    public let input = Input()
    
    public func apply(_ input: Event) {
        switch input {
        case .onAppear:
            self.input.onAppear.send(())
        case .create:
            self.input.create.send(())
        }
    }
    
    init(issueReporitory: IssueReporitory = IssueReporitoryImpl()) {
        self.issueReporitory = issueReporitory
        self.dateFormatter.dateFormat = "yyyy-MM-dd"
        
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
                self.issueReporitory.getUserlist()
                    .catch { _ -> Empty<[IssueUser], Never> in
                        return .init()
                    }
            }
            .map { $0.map { return SelectIssueUser(user: $0) } }
            .assign(to: \.users, on: self)
            .store(in: &bag)
        
        input.onAppear
            .flatMap {
                self.issueReporitory.getTaglist()
                    .catch { _ -> Empty<[IssueTag], Never> in
                        return .init()
                    }
            }
            .map { $0.map { SelectIssueTag(tag: $0) } }
            .assign(to: \.tags, on: self)
            .store(in: &bag)
        
        input.create
            .flatMap {
                self.issueReporitory.createIssue(title: self.title,
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
            .sink(receiveValue: { _ in
                self.apply(.onAppear)
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
