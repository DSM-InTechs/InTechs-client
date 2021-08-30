//
//  IssueDetailView.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/26.
//

import SwiftUI

struct IssueDetailView: View {
   
    var body: some View {
        VStack {
            Text("Hello, World!")
        }.introspectTabBarController { (UITabBarController) in
            UITabBarController.tabBar.isHidden = true
        }
    }
}

struct IssueDetailView_Previews: PreviewProvider {
    static var previews: some View {
        IssueDetailView()
    }
}
