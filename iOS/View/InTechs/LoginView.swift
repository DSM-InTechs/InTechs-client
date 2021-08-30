//
//  LoginView.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/27.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var homeVM: HomeViewModel
    @ObservedObject private var InTechsVM = InTechsViewModel()
    @ObservedObject private var keyboard = KeyboardObserver()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color(Asset.inTechsLeft)
            
            VStack {
                HStack {
                    Text("로그인")
                        .foregroundColor(Color(Asset.white))
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                }.padding()
               
                Spacer()
            }.padding()
            .padding(.vertical)
            
            ZStack {
                Color(Asset.white)
                    .cornerRadius(40)
                
                VStack {
                    VStack(spacing: UIFrame.width / 10) {
                        VStack(spacing: 5) {
                            HStack(spacing: 20) {
                                Image(system: .emailFill)
                                TextField("이메일을 입력하세요", text: $InTechsVM.email)
                            }
                            Color.gray.frame(height: 1)
                        }
                        
                        VStack(spacing: 5) {
                            HStack(spacing: 20) {
                                Image(system: .lockFill)
                                SecureField("비밀번호를 입력하세요", text: $InTechsVM.password)
                            }
                            Color.gray.frame(height: 1)
                            
                            HStack {
                                Spacer()
                                Text("비밀번호 찾기")
                                    .foregroundColor(Color(Asset.inTechsLeft))
                                    .padding(.trailing, 10)
                            }
                        }
                    }.padding(.vertical, UIFrame.width / 10)
                    
                    Spacer()
                    
                    if InTechsVM.email != "" && InTechsVM.password != "" {
                        Text("로그인")
                            .foregroundColor(Color(Asset.white))
                            .font(.title2)
                            .fontWeight(.medium)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(Asset.black)).frame(width: UIFrame.width / 1.2))
                            .onTapGesture {
                                if     self.InTechsVM.login() {
                                    withAnimation {
                                        self.homeVM.isLogin = true
                                    }
                                }
                            }
                            .padding(.vertical, UIFrame.width / 8)
                    } else {
                        Text("로그인")
                            .foregroundColor(Color(Asset.white))
                            .font(.title2)
                            .fontWeight(.medium)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(Asset.black).opacity(0.3)).frame(width: UIFrame.width / 1.2))
                            .modifier(Shake(animatableData: CGFloat(InTechsVM.attempts)))
                            .padding(.vertical, UIFrame.width / 8)
                    }
                }.padding()
                .padding(.horizontal)
                
            }.frame(height: keyboard.isKeyboard ? UIFrame.height / 1.7 : UIFrame.height / 2)
            .navigationBarTitle("", displayMode: .inline)
        } .ignoresSafeArea(edges: .bottom)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
