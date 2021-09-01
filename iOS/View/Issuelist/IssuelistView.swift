//
//  IssuelistView.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/26.
//

import SwiftUI

struct IssuelistView: View {
    @State private var uiTabarController: UITabBarController?
    @State var isPlus: Bool = false
    @State var selection = 0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 3) {
                ScrollView(.horizontal) {
                    HStack(spacing: 5) {
                        Text("For me & Unresolved")
                            .padding(.all, 5)
                            .padding(.horizontal, 5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(Asset.black), lineWidth: 2)
                            )
                        
                        Text("For me")
                            .padding(.all, 5)
                            .padding(.horizontal, 5)
                            .foregroundColor(.gray)
                        
                        Text("Unresolved")
                            .padding(.all, 5)
                            .padding(.horizontal, 5)
                            .foregroundColor(.gray)
                        
                        Text("Resolved")
                            .padding(.all, 5)
                            .padding(.horizontal, 5)
                            .foregroundColor(.gray)
                    }.padding()
                }
                
                Divider()
                    .padding(.horizontal)
                
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(0...1, id: \.self) { _ in
                            NavigationLink(destination: IssueDetailView()) {
                                CalendarIssueRow()
                            }
                        }
                    }
                    .padding()
                }
                .sheet(isPresented: self.$isPlus) {
//                    CreateIssueView()
                }
                .navigationBarTitle("이슈", displayMode: .inline)
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
//                        Image(system: .plus)
//                            .foregroundColor(.blue)
//                            .onTapGesture {
//                                self.isPlus = true
//                            }
                    }
                }
                .introspectTabBarController { (UITabBarController) in
                    UITabBarController.tabBar.isHidden = false
                    uiTabarController = UITabBarController
                }.onAppear {
                    uiTabarController?.tabBar.isHidden = false
                }
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
