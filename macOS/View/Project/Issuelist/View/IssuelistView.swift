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
                            Text("대상자")
                            Image(system: .downArrow)
                                .font(.caption)
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
