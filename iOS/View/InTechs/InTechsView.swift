//
//  InTechsView.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/27.
//

import SwiftUI

struct InTechsView: View {
    @EnvironmentObject private var homeVM: HomeViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(Asset.white)
                
                VStack(spacing: 20) {
                    LinearGradient(gradient: Gradient(colors: [Color(Asset.inTechsLeft), Color(Asset.inTechsRight)]),
                                   startPoint: .leading,
                                   endPoint: .trailing)
                        .mask(
                            Text("InTechs")
                                .font(.system(size: 60))
                                .fontWeight(.bold)
                        ).frame(height: UIFrame.width / 1.5)
                    
                    NavigationLink(destination: LoginView()) {
                        Text("로그인")
                            .foregroundColor(Color(Asset.white))
                            .font(.title2)
                            .fontWeight(.medium)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(Asset.black)).frame(width: UIFrame.width / 1.2))
                    }
                    
                    NavigationLink(destination: RegisterView()) {
                        Text("회원가입")
                            .foregroundColor(Color(Asset.black))
                            .font(.title2)
                            .fontWeight(.medium)
                            .padding()
                            .frame(width: UIFrame.width / 1.2)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(Asset.black), lineWidth: 2)
                            )
                            .padding(.bottom, UIFrame.width / 5)
                    }
                }
            }
        }
    }
}

struct InTechsView_Previews: PreviewProvider {
    static var previews: some View {
        InTechsView()
            .environmentObject(HomeViewModel())
    }
}
