//
//  LoginView.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/08/24.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    @ObservedObject var InTechsVM = InTechsViewModel()
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                Color(Asset.inTechsLeft)
                
                VStack {
                    HStack {
                        Text("로그인")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(.title)
                            .padding()
                        Spacer()
                    }
                    Spacer()
                }
                
                VStack {
                    VStack(spacing: 20) {
                        Spacer()
                        HStack(spacing: 10) {
                            Image(system: .emailFill)
                                .foregroundColor(Color(Asset.white))
                                .font(.title2)
                            
                            VStack(spacing: 3) {
                                TextField("이메일을 입력하세요", text: $InTechsVM.email)
                                    .colorMultiply(Color(Asset.white))
                                    .textFieldStyle(PlainTextFieldStyle())
                                Color(Asset.white).frame(height: 1)
                            }
                        }
                        
                        HStack(spacing: 10) {
                            Image(system: .lockFill)
                                .foregroundColor(Color(Asset.white))
                                .font(.title2)
                                .padding(.bottom, 15)
                            
                            VStack(spacing: 3) {
                                SecureField("비밀번호를 입력하세요", text: $InTechsVM.password)
                                    .colorMultiply(Color(Asset.white))
                                    .textFieldStyle(PlainTextFieldStyle())
                                Color(Asset.white).frame(height: 1)
                                
                                HStack {
                                    Spacer()
                                    Text("비밀번호 찾기")
                                        .foregroundColor(Color(Asset.inTechsLeft))
                                }
                            }
                        }
                        Spacer()
                    }.padding(.horizontal)
                    
                    if InTechsVM.email != "" && InTechsVM.password != "" { Text("로그인")
                        .foregroundColor(Color(Asset.black))
                        .font(.title2)
                        .fontWeight(.medium)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(Asset.white)).frame(width: geo.size.width / 2))
                        .onTapGesture {
                            self.InTechsVM.apply(.login)
                        }
                        .padding(.bottom)
                    } else {
                        Text("로그인")
                            .foregroundColor(Color(Asset.black))
                            .font(.title2)
                            .fontWeight(.medium)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(Asset.white).opacity(0.3)).frame(width: geo.size.width / 2))
                            .padding(.bottom)
                    }
                } 
                .frame(height: geo.size.height / 1.5)
                .background(Color(Asset.black))
                
                if self.InTechsVM.errorMessage != "" {
                    ErrorView(message: self.InTechsVM.errorMessage)
                        .onTapGesture {
                            self.InTechsVM.errorMessage = ""
                        }
                }
            }
        }.onAppear {
            self.InTechsVM.successExecute = {
                NSApplication.shared.keyWindow?.close()
                withAnimation {
                    self.homeVM.isLogin = true
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoginView()
                .preferredColorScheme(.dark)
            LoginView()
                .preferredColorScheme(.light)
        }
    }
}
