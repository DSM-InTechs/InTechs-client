//
//  IssuelistView.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/26.
//

import SwiftUI

struct IssuelistView: View {
    @State private var uiTabarController: UITabBarController?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 3) {
                HStack(spacing: 5) {
                    Circle().frame(width: 5, height: 5)
                    Text("For me & Unresolved")
                        .padding(.all, 5)
                        .padding(.horizontal, 5)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.green.opacity(0.2)))
                    
                    Spacer()
                }.padding()
                
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
                .navigationBarTitle("이슈", displayMode: .inline)
                .introspectTabBarController { (UITabBarController) in
                    UITabBarController.tabBar.isHidden = false
                    uiTabarController = UITabBarController
                }.onAppear() {
                    uiTabarController?.tabBar.isHidden = false
                }
            }
        }
    }
}

struct IssuelistView_Previews: PreviewProvider {
    static var previews: some View {
        IssuelistView()
    }
}
