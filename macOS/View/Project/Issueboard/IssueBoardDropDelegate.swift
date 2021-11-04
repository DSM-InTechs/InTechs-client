//
//  IssueBoardDropDelegate.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/08/22.
//

import SwiftUI
import Combine

struct IssueBoardDropDelegate: DropDelegate {
    let issueIndex: (Int, Int)
    let toChange: Int
    @Binding var allIssues: [[Issue]]
    // https://kavsoft.dev/SwiftUI_2.0/Grid_Reordering
    
    private let issueReporitory: IssueReporitory
    private var bag = Set<AnyCancellable>()
    
    init(issueIndex: (Int, Int),
         toChange: Int,
         allIssues: Binding<[[Issue]]>,
         issueReporitory: IssueReporitory = IssueReporitoryImpl()) {
        self.issueIndex = issueIndex
        self.toChange = toChange
        self._allIssues = allIssues
        self.issueReporitory = issueReporitory
    }
    
    func performDrop(info: DropInfo) -> Bool {
        var state = IssueState.ready
        var current = Issue(id: "", writer: "", title: "", projectId: 0, users: [], tags: [])
        
        // Get State
        if toChange == 1 {
            state = .progress
        } else if toChange == 2 {
            state = .done
        }
        
        // Change
        allIssues[issueIndex.0][issueIndex.1].state = state.rawValue
        current = allIssues[issueIndex.0][issueIndex.1]
        
        let issues = allIssues.flatMap({ $0 })
        let ready = issues.filter { $0.state == IssueState.ready.rawValue }
        let progress = issues.filter { $0.state == IssueState.progress.rawValue }
        let done = issues.filter { $0.state == IssueState.done.rawValue }
        allIssues = [ready, progress, done]
        
        issueReporitory.modifyIssueVoid(id: current.id, title: current.title, body: current.content, date: current.endDate, progress: current.progress, state: current.state, users: current.users.map { $0.email }, tags: current.tags.map { $0.tag })
        
        return true
    }
}
