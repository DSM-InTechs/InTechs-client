//
//  NewIssueViewModel.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/10/24.
//

import Combine
import Moya

class NewIssueViewModel: ObservableObject {
    @Published var issues = [Issue]()
    @Published var title: String = ""
    @Published var body: String?
    
    @Published var isDate: Bool = false
    @Published var date: Date = Date()
    @Published var isProgress: Bool = false
    @Published var progress: Float = 0.0
    @Published var state: IssueState?
    
    @Published var searchUser = ""
    @Published var users: [String] = []
    @Published var selectedUsers: [String]?
    @Published var tags: [String] = []
    @Published var searchTag = ""
    @Published var selectedTags: [String]?
    
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
        
        input.create
            .flatMap {
                self.issueReporitory.createIssue(title: self.title,
                                                 body: self.body,
                                                 date: self.isDate ? self.dateFormatter.string(from: self.date) : nil,
                                                 progress: Int(self.progress),
                                                 state: self.state?.rawValue,
                                                 users: self.selectedUsers,
                                                 tags: self.selectedTags)
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
