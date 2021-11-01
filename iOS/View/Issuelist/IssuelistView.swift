//
//  IssuelistView.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/26.
//

import SwiftUI

struct IssuelistView: View {
    @ObservedObject var viewModel = IssuelistViewModel()
    @State private var uiTabarController: UITabBarController?
    @State var selection = 0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 3) {
                ScrollView(.horizontal) {
                    HStack(spacing: 5) {
                        Text("For me & Unresolved")
                            .padding(.all, 5)
                            .padding(.horizontal, 5)
                            .foregroundColor(self.viewModel.selectedTab == .forMeAndUnresolved ? .black : .gray)
                            .overlay(
                                ZStack {
                                    if self.viewModel.selectedTab == .forMeAndUnresolved {
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color(Asset.black), lineWidth: 2)
                                    }
                                }
                            )
                            .onTapGesture {
                                self.viewModel.selectedTab = .forMeAndUnresolved
                                self.viewModel.modifyState()
                            }
                        
                        Text("For me")
                            .padding(.all, 5)
                            .padding(.horizontal, 5)
                            .foregroundColor(self.viewModel.selectedTab == .forMe ? .black : .gray)
                            .overlay(
                                ZStack {
                                    if self.viewModel.selectedTab == .forMe {
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color(Asset.black), lineWidth: 2)
                                    }
                                }
                            )
                            .onTapGesture {
                                self.viewModel.selectedTab = .forMe
                                self.viewModel.modifyState()
                            }
                        
                        Text("Unresolved")
                            .padding(.all, 5)
                            .padding(.horizontal, 5)
                            .foregroundColor(self.viewModel.selectedTab == .unresolved ? .black : .gray)
                            .overlay(
                                ZStack {
                                    if self.viewModel.selectedTab == .unresolved {
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color(Asset.black), lineWidth: 2)
                                    }
                                }
                            )
                            .onTapGesture {
                                self.viewModel.selectedTab = .unresolved
                                self.viewModel.modifyState()
                            }
                        
                        Text("Resolved")
                            .padding(.all, 5)
                            .padding(.horizontal, 5)
                            .foregroundColor(self.viewModel.selectedTab == .resolved ? .black : .gray)
                            .overlay(
                                ZStack {
                                    if self.viewModel.selectedTab == .resolved {
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color(Asset.black), lineWidth: 2)
                                    }
                                }
                            )
                            .onTapGesture {
                                self.viewModel.selectedTab = .resolved
                                self.viewModel.modifyState()
                            }
                        
                    }.padding()
                }
                
                Divider()
                    .padding(.horizontal)
                
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(viewModel.issues, id: \.self) { issue in
                            NavigationLink(destination: IssueDetailView(id: issue.id)) {
                                CalendarIssueRow(state: issue.state, title: issue.title)
                            }
                        }
                    }
                    .padding()
                }
                .navigationBarTitle("이슈", displayMode: .inline)
                .introspectTabBarController { (UITabBarController) in
                    UITabBarController.tabBar.isHidden = false
                    uiTabarController = UITabBarController
                }.onAppear {
                    uiTabarController?.tabBar.isHidden = false
                }
            }.onAppear {
                viewModel.apply(.onAppear)
            }
        }
    }
}

struct CreateIssueView: View {
    @Binding var text: String
    @Binding var isModal: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.secondarySystemBackground)
                    .ignoresSafeArea()
                
                GeometryReader { _ in
                    VStack(spacing: UIFrame.width / 10) {
                        VStack(alignment: .leading, spacing: 3) {
                            Text("필수")
                                .foregroundColor(.gray)
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding(.bottom, 5)
                            
                            TextField("제목을 입력해주세요", text: $text)
                                .padding(.all, 15)
                                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(Asset.white)))
                        }
                        
                        VStack(alignment: .leading, spacing: 3) {
                            Text("선택")
                                .foregroundColor(.gray)
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding(.bottom, 5)
                            
                            TextField("내용을 입력해주세요", text: $text)
                                .padding(.all, 15)
                                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(Asset.white)))
                            
                            TextField("대상자", text: $text)
                                .padding(.all, 15)
                                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(Asset.white)))
                            
                            TextField("마감기한", text: $text)
                                .padding(.all, 15)
                                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(Asset.white)))
                            
                            TextField("태그", text: $text)
                                .padding(.all, 15)
                                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(Asset.white)))
                            
                            TextField("프로그레스", text: $text)
                                .padding(.all, 15)
                                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(Asset.white)))
                        }
                    }.padding()
                }
                .navigationBarTitle("이슈 생성", displayMode: .inline)
                .navigationBarItems(leading: Text("취소")
                                        .foregroundColor(.red).onTapGesture {
                    self.isModal.toggle()
                }, trailing: Text("확인")
                                        .foregroundColor(text == "" ? .gray : .blue))
            }
        }
    }
}

struct IssuelistView_Previews: PreviewProvider {
    static var previews: some View {
        IssuelistView()
        CreateIssueView(text: .constant(""), isModal: .constant(false))
    }
}
