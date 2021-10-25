//
//  InTechsView.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/24.
//

import SwiftUI

struct InTechsView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    
    var body: some View {
        GeometryReader { geo in
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
                        )
                    
                    Button(action: {
                        OpenWindows.loginView.open()
                    }, label: {
                        Text("로그인")
                            .foregroundColor(Color(Asset.white))
                            .font(.title2)
                            .fontWeight(.medium)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(Asset.black)).frame(width: geo.size.width / 2))
                        
                    }).buttonStyle(PlainButtonStyle())
                    
                    Button(action: {
                        OpenWindows.registerView.open()
                    }, label: {
                        Text("회원가입")
                            .foregroundColor(Color(Asset.black))
                            .font(.title2)
                            .fontWeight(.medium)
                            .padding()
                            .frame(width: geo.size.width / 2)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(Asset.black), lineWidth: 2)
                            )
                    }).buttonStyle(PlainButtonStyle())
                    .padding(.bottom, 50)
                }
            }
        } 
    }
}

struct InTechsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            InTechsView()
                .preferredColorScheme(.dark)
            InTechsView()
                .preferredColorScheme(.light)
        }
    }
}
