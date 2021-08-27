//
//  MypageView.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/08/26.
//

import SwiftUI

struct MypageView: View {
    @State var uiTabarController: UITabBarController?
    
    var body: some View {
        ZStack {
            Color(UIColor.secondarySystemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 25) {
                NavigationLink(destination: MypageEditView()) {
                    HStack {
                        Circle().frame(width: 40, height: 40)
                        VStack(alignment: .leading) {
                            Text("유저 이름")
                            Text("편집")
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("설정")
                    MypageRow(title: "알림", image: .bell)
                }
                
                VStack(alignment: .leading) {
                    MypageRow(title: "로그아웃", image: .bell)
                        .foregroundColor(.red)
                }
                
            }.padding()
        }.introspectTabBarController { (UITabBarController) in
            UITabBarController.tabBar.isHidden = true
            uiTabarController = UITabBarController
        }
//        .onDisappear{
//            uiTabarController?.tabBar.isHidden = false
//        }
    }
}

struct MypageRow: View {
    let title: String
    let image: SFImage
    
    var body: some View {
        HStack {
            Image(system: image)
            Text(title)
            Spacer()
        }.padding()
        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(Asset.white)))
    }
}

struct MypageView_Previews: PreviewProvider {
    static var previews: some View {
        MypageView()
    }
}
