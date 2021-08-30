//
//  MypageEditView.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/26.
//

import SwiftUI

struct MypageEditView: View {
    @State var uiTabarController: UITabBarController?
    
    var body: some View {
        VStack {
            Text("Hello, World!")
        }
        .introspectTabBarController { (UITabBarController) in
            UITabBarController.tabBar.isHidden = true
            uiTabarController = UITabBarController
        }
    }
}

struct MypageEditView_Previews: PreviewProvider {
    static var previews: some View {
        MypageEditView()
    }
}
