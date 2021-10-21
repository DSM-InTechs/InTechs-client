//
//  Issulist.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/22.
//

import SwiftUI

struct IssuelistView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    @ObservedObject var viewModel = IssuelistViewModel()
    @State private var currentIssue: Issue? = nil
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Unresolved 2")
                            .padding(.all, 5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .strokeBorder(Color.blue, lineWidth: 2)
                            )
                        
                        Text("For me 2")
                            .padding(.all, 5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .strokeBorder(Color.gray.opacity(0.3))
                            )
                        
                        Text("For me & Unresolved 2")
                            .padding(.all, 5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .strokeBorder(Color.gray.opacity(0.3))
                            )
                        
                        Text("Resolved 2")
                            .padding(.all, 5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .strokeBorder(Color.gray.opacity(0.3))
                            )
                        
                        Spacer()
                        
                        Text("새 이슈")
                            .padding(.all, 5)
                            .background( RoundedRectangle(cornerRadius: 5)
                                            .foregroundColor(.blue))
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
                            IssueDetailView(currentIssue: $currentIssue, title: "이슈1")
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
                Circle().frame(width: 10, height: 10)
                Text(issue.title)
            }
            
            Spacer()
            
//            if !issue.users.isEmpty {
                
                    HStack(spacing: -10) {
                        Circle().frame(width: 20, height: 20)
                        Circle().frame(width: 20, height: 20)
                        Circle().frame(width: 20, height: 20)
                        Text("+5")
                            .foregroundColor(.black)
                            .font(.caption)
                            .background(Circle().frame(width: 20, height: 20))
                    }
//            }
            
//            HStack {
//                Circle().frame(width: 20, height: 20)
//                Text("대상자")
//            }
            
            if issue.endDate != nil {
                Text(issue.endDate!)
                    .foregroundColor(.red)
            }
            
        }.padding(.all, 5)
            .onTapGesture {
                withAnimation {
                    self.currentIssue = issue
                }
            }
    }
}
