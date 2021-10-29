//
//  IssueBoardView.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/08/22.
//

import SwiftUI
import Foundation
import Kingfisher

struct IssueBoardView: View {
    @State var currrentIssue: Issue?
    let columns = Array(repeating: GridItem(.flexible(), spacing: 20), count: 3)
    @ObservedObject var viewModel = IssueBoardViewModel()
    
    @State private var assigneePop: Bool = false
    @State private var statePop: Bool = false
    @State private var tagPop: Bool = false
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack(spacing: 20) {
                    HStack(spacing: 3) {
                        Text("상태")
                        Image(system: .downArrow)
                            .font(.caption)
                    }.onTapGesture {
                        self.statePop.toggle()
                    }.popover(isPresented: self.$statePop) {
                        IssueFilterStateView(state: $viewModel.state,
                                             execute: { viewModel.apply(.reloadlist) })
                            .padding()
                    }
                    
                    HStack(spacing: 3) {
                        Text("대상자")
                        Image(system: .downArrow)
                            .font(.caption)
                    }.onTapGesture {
                        self.assigneePop.toggle()
                    }.popover(isPresented: self.$assigneePop) {
                        IssueFilterUserView(users: $viewModel.users,
                                            execute: { viewModel.apply(.reloadlist) })
                            .frame(width: 200)
                    }
                    
                    HStack(spacing: 3) {
                        Text("태그")
                        Image(system: .downArrow)
                            .font(.caption)
                    }.onTapGesture {
                        self.tagPop.toggle()
                    }.popover(isPresented: self.$tagPop) {
                        IssueFilterTagView(tags: $viewModel.tags,
                                           execute: { viewModel.apply(.reloadlist) })
                            .frame(width: 200)
                    }
                    
                    HStack(spacing: 3) {
                        Image(system: .search)
                        TextField("검색", text: .constant(""))
                            .textFieldStyle(PlainTextFieldStyle())
                    }
                    
                    Spacer()
                }
            }
            
            Divider()
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    if viewModel.allIssues.isEmpty == false {
                        ForEach(0...viewModel.allIssues.count - 1, id: \.self) { index in
                            HStack {
                                LazyVStack {
                                    Section(header:
                                                HStack(spacing: 5) {
                                        Text(viewModel.headers[index])
                                        Text(String(viewModel.allIssues[index].count))
                                            .foregroundColor(.gray)
                                        Spacer()
                                    }) {
                                        ForEach(viewModel.allIssues[index], id: \.self) { issue in
                                            IssueBoardIssueRow(title: issue.title, assignee: issue.users)
                                                .onDrag({
                                                    self.currrentIssue = issue
                                                    return NSItemProvider(contentsOf: URL(string: issue.id)!)! // arr.id로 변경 필요
                                                })
                                                                                        .onDrop(of: [.url], delegate: IssueBoardDropDelegate(issue: issue, current: currrentIssue, allIssues: viewModel.allIssues[index]))
                                            
                                            Spacer(minLength: 0)
                                        }
                                    }
                                }
                                
                                if index != 2 {
                                    Divider().padding(.leading, 5)
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .padding(.trailing, 70)
        .ignoresSafeArea(.all, edges: .all)
        .onAppear {
            self.viewModel.apply(.onAppear)
        }
    }
}

struct IssueBoardIssueRow: View {
    let title: String
    let assignee: [IssueUser]?
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                if assignee != nil && assignee?.isEmpty == false {
                    HStack {
                        KFImage(URL(string: assignee!.first!.imageURL))
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text(assignee!.first!.name)
                        if assignee!.count != 1 {
                            Text("외 \(assignee!.count - 1)명")
                        }
                    }
                    
                }
            }
            Spacer()
        }
        .padding(.all, 5)
        .background(
            RoundedRectangle(cornerRadius: 5).fill(Color.gray.opacity(0.1))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .strokeBorder(Color.gray.opacity(0.3), lineWidth: 1)
        )
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
