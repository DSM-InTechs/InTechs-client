//
//  IssueBoardDropDelegate.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/08/22.
//

import SwiftUI

struct IssueBoardDropDelegate: DropDelegate {
    var issue: Issue
    var current: Issue?
    var allIssues: [Issue] // 나중에 viewModel로 바꾸면 될듯.
    // https://kavsoft.dev/SwiftUI_2.0/Grid_Reordering
    
    func performDrop(info: DropInfo) -> Bool {
        return true
    }
    
    mutating func dropEntered(info: DropInfo) {
        let fromIndex = allIssues.firstIndex { issue -> Bool in
            return issue.id == current?.id
        } ?? 0
        
        let toIndex = allIssues.firstIndex { issue -> Bool in
            return issue.id == self.issue.id
        } ?? 0
        
        if fromIndex != toIndex {
            withAnimation(.default) {
                let fromPage = allIssues[fromIndex]
                allIssues[fromIndex] = allIssues[toIndex]
                allIssues[toIndex] = fromPage
            }
        }
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
    
}
