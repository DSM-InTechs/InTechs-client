//
//  IssueBoardView.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/08/22.
//

import SwiftUI
import Foundation

struct Issue: Hashable, Identifiable {
    var id = UUID().uuidString
    var type: String
    var title: String
    var assignee: String
}

var all: [[Issue]] = [open, progress, done]

var open = [Issue(type: "Open", title: "이슈1", assignee: "대상자"), Issue(type: "Open", title: "이슈2", assignee: "대상자")] // 와.. 이슈가 똑같은게잇으면 Lazy에서 오류남 ;;;
var progress = [Issue(type: "In progress", title: "이슈3", assignee: "대상자"), Issue(type: "In progress", title: "이슈4", assignee: "대상자")]
var done = [Issue(type: "Done", title: "이슈5", assignee: "대상자"), Issue(type: "Done", title: "이슈6", assignee: "대상자")]

struct IssueBoardView: View {
    @State var currrentIssue: Issue?
    let columns = Array(repeating: GridItem(.flexible(), spacing: 20), count: 3)
    
    @State private var filterPop = false
    @State private var assigneePop = false
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack(spacing: 20) {
                    HStack(spacing: 3) {
                        Text("대상자")
                        Image(system: .downArrow)
                            .font(.caption)
                    }.onTapGesture {
                        self.assigneePop.toggle()
                    }
                    
                    HStack(spacing: 3) {
                        Text("마감기한")
                        Image(system: .downArrow)
                            .font(.caption)
                    }
                    
                    HStack(spacing: 3) {
                        Text("태그")
                        Image(system: .downArrow)
                            .font(.caption)
                    }
                    
                    Spacer()
                }
            }
            
            Divider()
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(all, id: \.self) { issues in
                        HStack {
                            LazyVStack {
                                Section(header:
                                            HStack(spacing: 5) {
                                                Text(issues.first!.type)
                                                Text("2")
                                                    .foregroundColor(.gray)
                                                Image(system: .plus)
                                                    .padding(.leading, 5)
                                                Spacer()
                                            }) {
                                    ForEach(issues, id: \.self) { issue in
                                        IssueBoardIssueRow(title: issue.title, assignee: issue.assignee)
                                            .onDrag({
                                                self.currrentIssue = issue
                                                return NSItemProvider(contentsOf: URL(string: issue.id)!)! // arr.id로 변경 필요
                                            })
                                            .onDrop(of: [.url], delegate: IssueBoardDropDelegate(issue: issue, current: currrentIssue, allIssues: issues))
                                    }
                                }
                            }
                            
                            if issues != all.last { // 원래는 id로 비교
                                Divider()
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .padding(.trailing, 70)
        .ignoresSafeArea(.all, edges: .all)
    }
}

struct IssueBoardIssueRow: View {
    let title: String
    let assignee: String
    
    var body: some View {
        if title != "" { // type을 위해서 기본 "" 이 들어갈거라서 검사하기
            HStack {
                VStack(spacing: 5) {
                    Text(title)
                    Text(assignee)
                }
                Spacer()
            }
            .padding(.all, 10)
            .background(
                RoundedRectangle(cornerRadius: 5).fill(Color.gray.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .strokeBorder(Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
    }
}

struct AssigneelistPopView: View {
    @State var text = ""
    @Binding var array: [String]
    var body: some View {
        VStack {
            CustomTextField(text: $text, placeholder: "Find a person")
            
            LazyVStack(alignment: .leading, spacing: 10) {
                Text("Unassigned")
                ForEach(array, id: \.self) { person in
                    Text(person)
                        .id(UUID())
                }
            }
        }.padding()
    }
}

struct IssueBoardView_Previews: PreviewProvider {
    static var previews: some View {
        IssueBoardView()
    }
}
