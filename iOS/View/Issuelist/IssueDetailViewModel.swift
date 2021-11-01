//
//  IssueDetailViewModel.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/11/01.
//

import Combine
import Moya

class IssueDetailViewModel: ObservableObject {
    @Published var issue = Issue(id: "", writer: "", title: "", content: nil, state: nil, progress: nil, endDate: nil, projectId: 0, users: [IssueUser](), tags: [IssueTag](), comments: nil)
    @Published var date = Date()
    
    private let issueReporitory: IssueReporitory
    private let dateFomatter = DateFormatter()
    
    private var bag = Set<AnyCancellable>()
    
    public enum Event {
        case onAppear(id: String)
    }
    
    public struct Input {
        let onAppear = PassthroughSubject<String, Never>()
    }
    
    public let input = Input()
    
    public func apply(_ input: Event) {
        switch input {
        case .onAppear(let id):
            self.input.onAppear.send(id)
        }
    }
    
    init(issueReporitory: IssueReporitory = IssueReporitoryImpl()) {
        self.issueReporitory = issueReporitory
        self.dateFomatter.dateFormat = "yyyy-MM-dd"
        
        input.onAppear
            .flatMap {
                self.issueReporitory.getDetailIssue(id: $0)
                    .catch { _ -> Empty<Issue, Never> in
                        return .init()
                    }
            }
            .sink(receiveValue: {
                self.issue = $0
                if $0.endDate != nil {
                    self.date = self.dateFomatter.date(from: $0.endDate!)!
                }
            })
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
