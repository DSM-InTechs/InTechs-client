//
//  IssueDetailView.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/26.
//

import SwiftUI

struct IssueDetailView: View {
    @State private var date = Date()
    
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
                            Text("이슈 1")
                            Spacer()
                        }.padding()
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(Asset.white)))
                        
                        HStack(spacing: 20) {
                            Text("설명")
                                .foregroundColor(.gray)
                            Text("비어있음")
                                .foregroundColor(.gray)
                            Spacer()
                        }.padding()
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(Asset.white)))
                    }
                    
                    VStack(alignment: .leading) {
                        
                        HStack(spacing: 20) {
                            Text("대상자")
                                .foregroundColor(.gray)
                            // HStack Scroll로
                            Text("비어있음")
                                .foregroundColor(.gray)
                            Spacer()
                        }.padding()
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(Asset.white)))
                    }
                    
                    VStack(alignment: .leading) {
                        
                        HStack(spacing: 20) {
                            Text("태그")
                                .foregroundColor(.gray)
                            // HStack Scroll로
                            Text("비어있음")
                                .foregroundColor(.gray)
                            Spacer()
                        }.padding()
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(Asset.white)))
                    }
                    
                    VStack(alignment: .leading) {
                        
                        HStack(spacing: 20) {
                            Text("마감일")
                                .foregroundColor(.gray)
                            // HStack Scroll로
                            DatePicker("", selection: .constant(date), displayedComponents: .date)
                                .datePickerStyle(CompactDatePickerStyle())
                                .clipped()
                                   .labelsHidden()
                            //                                Text("비어있음")
                            //                                    .foregroundColor(.gray)
                            Spacer()
                        }.padding()
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(Asset.white)))
                    }
                    
                }.padding()
            }
        }
        .navigationBarTitle("이슈 이름")
        .introspectTabBarController { (UITabBarController) in
            UITabBarController.tabBar.isHidden = true
        }
    }
}

struct IssueDetailView_Previews: PreviewProvider {
    static var previews: some View {
        IssueDetailView()
    }
}
