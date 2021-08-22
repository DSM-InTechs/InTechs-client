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

var open = [Issue(type: "open", title: "이슈1", assignee: "asdf"), Issue(type: "open", title: "이슈2", assignee: "asdf")] // 와.. 이슈가 똑같은게잇으면 Lazy에서 오류남 ;;;
var progress = [Issue(type: "progress", title: "이슈3", assignee: "asdf"), Issue(type: "progress", title: "이슈4", assignee: "asdf")]
var done = [Issue(type: "done", title: "이슈5", assignee: "asdf"), Issue(type: "done", title: "이슈6", assignee: "asdf")]

struct IssueBoardView: View {
    @State var currrentIssue: Issue?
    let columns = Array(repeating: GridItem(.flexible(), spacing: 20), count: 3)
    
    @State private var filterPop = false
    @State private var assigneePop = false
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("IssueBoard")
                    Spacer()
                }
                HStack(spacing: 15) {
                    Button(action: {
                        self.assigneePop.toggle()
                    }) {
                        HStack(spacing: 5) {
                            Text("Assignee")
                            SystemImage(system: .downArrow)
                                .frame(width: 7, height: 7)
                        }
                    }.buttonStyle(PlainButtonStyle())
                    .popover(isPresented: $assigneePop) {
                        AssigneelistPopView( array: .constant(["사람1", "사람2"]))
                            .frame(width: 200)
                    }
                    
                    Button(action: {}) {
                        HStack(spacing: 5) {
                            Text("Created By")
                            SystemImage(system: .downArrow)
                                .frame(width: 7, height: 7)
                        }
                    }.buttonStyle(PlainButtonStyle())
                    
                    Button(action: {}) {
                        HStack(spacing: 5) {
                            Text("Tag")
                            SystemImage(system: .downArrow)
                                .frame(width: 7, height: 7)
                        }
                    }.buttonStyle(PlainButtonStyle())

                    Spacer()
                    
                    Button(action: {
                        self.filterPop.toggle()
                    }) {
                        HStack(spacing: 5) {
                            SystemImage(system: .plus)
                                .frame(width: 7, height: 7)
                            Text("More Filters")
                        }
                    }.buttonStyle(PlainButtonStyle())
                    .popover(isPresented: $filterPop) {
                        FilterPopView()
                    }
                   
                }
            }
            
            Divider()
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(all, id: \.self) { issues in
                        HStack {
                            LazyVStack {
                                Section(header: Text(issues.first!.type).font(.title)) {
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
//    var title: String
//    var assignee: String
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

struct FilterPopView: View {
    var body: some View {
        VStack {
            HStack {
                SystemImage(system: .checklist)
                    .frame(width: 15, height: 15)
                    .foregroundColor(.blue)
                Text("Assignee")
                    .fixedSize(horizontal: true, vertical: false)
            }
            HStack {
                SystemImage(system: .checklist)
                    .frame(width: 15, height: 15)
                    .foregroundColor(.blue)
                Text("Created By")
            }
            HStack {
                SystemImage(system: .square)
                    .frame(width: 15, height: 15)
                Text("Creation time")
            }
            HStack {
                SystemImage(system: .square)
                    .frame(width: 15, height: 15)
                Text("due date")
            }
            HStack {
                SystemImage(system: .checklist)
                    .frame(width: 15, height: 15)
                    .foregroundColor(.blue)
                Text("Tag")
            }
        }.padding()
    }
}

struct IssueBoardView_Previews: PreviewProvider {
    static var previews: some View {
        IssueBoardView()
    }
}
