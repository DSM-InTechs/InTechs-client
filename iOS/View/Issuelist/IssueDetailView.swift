//
//  IssueDetailView.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/26.
//

import SwiftUI
import Kingfisher

struct IssueDetailView: View {
    let id: String
    
    @ObservedObject var viewModel = IssueDetailViewModel()
    
    var body: some View {
        ZStack {
            Color(UIColor.secondarySystemBackground)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 25) {
                    VStack(alignment: .leading) {
                        HStack(spacing: 20) {
                            Text("이름")
                                .foregroundColor(.gray)
                            
                            Text(viewModel.issue.title)
                            Spacer()
                        }.padding()
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(Asset.white)))
                        
                        HStack(spacing: 20) {
                            Text("설명")
                                .foregroundColor(.gray)
                            
                            if viewModel.issue.content != nil {
                                Text(viewModel.issue.content!)
                            } else {
                                Text("비어있음")
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }.padding()
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(Asset.white)))
                    }
                    
                    VStack(alignment: .leading) {
                        HStack(spacing: 20) {
                            Text("대상자")
                                .foregroundColor(.gray)
                            
                            if viewModel.issue.users.isEmpty == false {
                                LazyHStack {
                                    ForEach(viewModel.issue.users, id: \.self) { user in
                                        HStack {
                                            KFImage(URL(string: user.name))
                                            
                                            Text(user.name)
                                        }
                                    }
                                }
                            } else {
                                Text("비어있음")
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }.padding()
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(Asset.white)))
                    }
                    
                    VStack(alignment: .leading) {
                        HStack(spacing: 20) {
                            Text("태그")
                                .foregroundColor(.gray)
                            
                            if viewModel.issue.tags.isEmpty
                                == false {
                                LazyHStack {
                                    ForEach(viewModel.issue.tags, id: \.self) { tag in
                                        HStack {
                                            Text("# \(tag.tag)")
                                        }
                                    }
                                }
                            } else {
                                Text("비어있음")
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }.padding()
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(Asset.white)))
                    }
                    
                    VStack(alignment: .leading) {
                        HStack(spacing: 20) {
                            Text("마감일")
                                .foregroundColor(.gray)
                            
                            if viewModel.issue.endDate != nil {
                                DatePicker("", selection: $viewModel.date, displayedComponents: .date)
                                    .datePickerStyle(CompactDatePickerStyle())
                                    .clipped()
                                    .labelsHidden()
                            } else {
                                Text("비어있음")
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }.padding()
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(Asset.white)))
                    }
                    
                    VStack(alignment: .leading) {
                        HStack(spacing: 20) {
                            Text("댓글")
                                .foregroundColor(.gray)
                            
                            if viewModel.issue.comments != nil {
                                LazyHStack {
                                    ForEach(viewModel.issue.comments!, id: \.self) { comment in
                                        HStack {
                                            VStack {
                                                KFImage(URL(string: comment.user.email))
                                                Text(comment.user.name)
                                            }
                                            Text(comment.content)
                                        }
                                    }
                                }
                            } else {
                                Text("비어있음")
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }.padding()
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(Asset.white)))
                    }
                    
                }.padding()
            }
        }
        .navigationBarTitle(viewModel.issue.title)
        .introspectTabBarController { (UITabBarController) in
            UITabBarController.tabBar.isHidden = true
        }.onAppear {
            self.viewModel.apply(.onAppear(id: self.id))
        }
    }
}

struct IssueDetailView_Previews: PreviewProvider {
    static var previews: some View {
        IssueDetailView(id: "")
    }
}
