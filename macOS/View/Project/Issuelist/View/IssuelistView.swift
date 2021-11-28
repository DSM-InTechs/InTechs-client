//
//  Issulist.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/22.
//

import SwiftUI
import Kingfisher

struct IssuelistView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    @ObservedObject var viewModel = IssuelistViewModel()
    @State private var currentIssue: Issue?
    
    @State private var assigneePop: Bool = false
    @State private var statePop: Bool = false
    @State private var tagPop: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Unresolved \(viewModel.dashboard.issuesCount.unresolved)")
                            .padding(.all, 5)
                            .overlay(
                                ZStack {
                                    if self.viewModel.selectedTab == .unresolved {
                                        RoundedRectangle(cornerRadius: 5)
                                            .strokeBorder(Color.blue, lineWidth: 2)
                                    } else {
                                        RoundedRectangle(cornerRadius: 5)
                                            .strokeBorder(Color.gray.opacity(0.3))
                                    }
                                }
                            ).onTapGesture {
                                if self.viewModel.selectedTab == .unresolved {
                                    self.viewModel.selectedTab = nil
                                } else {
                                    self.viewModel.selectedTab = .unresolved
                                    self.viewModel.state = IssueState.progress
                                    self.viewModel.apply(.reloadlist)
                                }
                            }
                        
                        Text("For me \(viewModel.dashboard.issuesCount.forMe)")
                            .padding(.all, 5)
                            .overlay(
                                ZStack {
                                    if self.viewModel.selectedTab == .forMe {
                                        RoundedRectangle(cornerRadius: 5)
                                            .strokeBorder(Color.blue, lineWidth: 2)
                                    } else {
                                        RoundedRectangle(cornerRadius: 5)
                                            .strokeBorder(Color.gray.opacity(0.3))
                                    }
                                }
                            ).onTapGesture {
                                if self.viewModel.selectedTab == .forMe {
                                    self.viewModel.selectedTab = nil
                                } else {
                                    self.viewModel.selectedTab = .forMe
                                    self.viewModel.apply(.getForMe)
                                }
                            }
                        
                        Text("For me & Unresolved \(viewModel.dashboard.issuesCount.forMeAndUnresolved)")
                            .padding(.all, 5)
                            .overlay(
                                ZStack {
                                    if self.viewModel.selectedTab == .forMeAndUnresolved {
                                        RoundedRectangle(cornerRadius: 5)
                                            .strokeBorder(Color.blue, lineWidth: 2)
                                    } else {
                                        RoundedRectangle(cornerRadius: 5)
                                            .strokeBorder(Color.gray.opacity(0.3))
                                    }
                                }
                            ).onTapGesture {
                                if self.viewModel.selectedTab == .forMeAndUnresolved {
                                    self.viewModel.selectedTab = nil
                                } else {
                                    self.viewModel.selectedTab = .forMeAndUnresolved
                                    self.viewModel.apply(.reloadlist)
                                }
                            }
                        
                        Text("Resolved \(viewModel.dashboard.issuesCount.resolved)")
                            .padding(.all, 5)
                            .overlay(
                                ZStack {
                                    if self.viewModel.selectedTab == .resolved {
                                        RoundedRectangle(cornerRadius: 5)
                                            .strokeBorder(Color.blue, lineWidth: 2)
                                    } else {
                                        RoundedRectangle(cornerRadius: 5)
                                            .strokeBorder(Color.gray.opacity(0.3))
                                    }
                                }
                            ).onTapGesture {
                                if self.viewModel.selectedTab == .resolved {
                                    self.viewModel.selectedTab = nil
                                } else {
                                    self.viewModel.selectedTab = .resolved
                                    self.viewModel.state = IssueState.done
                                }
                            }
                        
                        Spacer()
                        
                        Text("새 이슈")
                            .padding(.all, 5)
                            .background( RoundedRectangle(cornerRadius: 5)
                                            .foregroundColor(.blue))
                            .onTapGesture {
                                self.homeVM.toast = .issueCreate(execute: {
                                    self.viewModel.reload(.onAppear)
                                })
                            }
                    }
                    
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
                }.padding(.horizontal)
                    .padding(.top)
                
                HStack {
                    VStack(alignment: .leading) {
                        
                        Divider()
                        
                        Text("\(String(self.viewModel.issues.count))개의 이슈")
                            .padding(.bottom, 10)
                        
                        ScrollView {
                            LazyVStack {
                                ForEach(viewModel.issues, id: \.self) { issue in
                                    IssuelistRow(issue: issue, currentIssue: self.$currentIssue)
                                }
                            }
                        }.padding(.top, 5)
                    }.padding(.horizontal)
                    
                    Spacer(minLength: 0)
                    
                    // Issue...
                    if currentIssue != nil {
                        ZStack {
                            IssueDetailView(currentIssue: $currentIssue, title: currentIssue!.title)
                                .environmentObject(homeVM)
                            
                            HStack {
                                Color.black.frame(width: 1)
                                    .padding(.bottom, 10)
                                Spacer()
                            }
                        }.frame(width: geo.size.width / 3)
                            .ignoresSafeArea(.all)
                            .background(Color(NSColor.systemGray).opacity(0.1).padding(.bottom, 10))
                    }
                }
            }
            .padding(.trailing, 70)
            .ignoresSafeArea(.all, edges: .all)
            .onAppear {
                self.viewModel.apply(.onAppear)
            }
        }.ignoresSafeArea(.all, edges: .all)
    }
}

struct IssuelistView_Previews: PreviewProvider {
    static var previews: some View {
        IssuelistView()
        IssueFilterUserView(users: .constant([SelectIssueUser(user: IssueUser(name: "asdf", email: "asdf", imageURL: ""))])).frame(width: 200)
        IssueFilterTagView(tags: .constant([SelectIssueTag(tag: IssueTag(tag: "태그 예시"))])).frame(width: 200)
        IssueFilterStateView(state: .constant(IssueState.progress))
    }
}

struct IssuelistRow: View {
    let issue: Issue
    @Binding var currentIssue: Issue?
    
    var body: some View {
        HStack(spacing: 20) {
            HStack {
                switch issue.state {
                case .some(IssueState.ready.rawValue):
                    Circle().frame(width: 10, height: 10).foregroundColor(.blue)
                case .some(IssueState.progress.rawValue):
                    Circle().frame(width: 10, height: 10).foregroundColor(.gray)
                case .some(IssueState.done.rawValue):
                    Circle().frame(width: 10, height: 10).foregroundColor(.green)
                default:
                    Text("").hidden()
                }
                Text(issue.title)
                    .font(.title3)
            }
            
            Spacer()
            
            if issue.users.isEmpty == false {
                HStack {
                    ForEach(issue.users.prefix(3), id: \.self) { user in
                        KFImage(URL(string: user.imageURL))
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text(user.name)
                    }
                    if issue.users.count > 3 {
                        Text(String(issue.users.count - 3))
                            .foregroundColor(.black)
                            .font(.caption)
                            .background(Circle().frame(width: 20, height: 20))
                    }
                }
            }
            
            if issue.endDate != nil {
                if Date.compareWithToday(a: issue.endDate!) == 0 { // 날짜가 지난 경우 취소선
                    Text(issue.endDate!)
                        .foregroundColor(.gray)
                        .strikethrough()
                } else {
                    Text(issue.endDate!)
                        .foregroundColor(.red)
                }
            }
            
        }.padding(.all, 5)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(.gray.opacity(0.2))
            )
            .onTapGesture {
                withAnimation {
                    self.currentIssue = issue
                }
            }
    }
}

struct IssueFilterUserView: View {
    @Binding var users: [SelectIssueUser]
    var execute: () -> Void = {}
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(0...users.count - 1, id: \.self) { index in
                    IssueUserRow(user: users[index])
                        .onTapGesture {
                            users[index].isSelected.toggle()
                            self.execute()
                        }
                }
            }
        }.padding()
    }
}

struct IssueUserRow: View {
    let user: SelectIssueUser
    
    var body: some View {
        HStack {
            KFImage(URL(string: user.imageURL))
                .resizable()
                .frame(width: 25, height: 25)
            Text(user.name)
            Spacer()
            if user.isSelected {
                Image(system: .checkmark)
            }
        }
    }
}

struct IssueFilterTagView: View {
    @Binding var tags: [SelectIssueTag]
    var execute: () -> Void = {}
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(0...tags.count - 1, id: \.self) { index in
                    HStack {
                        Text("# \(tags[index].tag)")
                            .padding(.all, 10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10).foregroundColor(.clear).border(Color.gray.opacity(0.5))
                            )
                        Spacer()
                        if tags[index].isSelected {
                            Image(system: .checkmark)
                        }
                    }.onTapGesture {
                        tags[index].isSelected.toggle()
                        self.execute()
                    }
                }
            }
        }.padding()
    }
}

struct IssueFilterStateView: View {
    @Binding var state: IssueState?
    var execute: () -> Void = {}
    
    var body: some View {
        ScrollView {
            HStack {
                HStack {
                    Circle().frame(width: 10, height: 10)
                    Text("Ready")
                }.foregroundColor(.blue)
                    .opacity(self.state == .ready ? 1.0 : 0.5)
                    .onTapGesture {
                        self.state = .ready
                        self.execute()
                    }
                
                HStack {
                    Circle().frame(width: 10, height: 10)
                    Text("In Progress")
                } .foregroundColor(.gray)
                    .opacity(self.state == .progress ? 1.0 : 0.5)
                    .onTapGesture {
                        self.state = .progress
                        self.execute()
                    }
                
                HStack {
                    Circle().frame(width: 10, height: 10)
                    Text("Done")
                } .foregroundColor(.green)
                    .opacity(self.state == .done ? 1.0 : 0.5)
                    .onTapGesture {
                        self.state = .done
                        self.execute()
                    }
            }
            
        }
    }
}
