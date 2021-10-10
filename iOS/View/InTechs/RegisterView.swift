//
//  RegisterView.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/27.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    @ObservedObject private var InTechsVM = InTechsViewModel()
    @ObservedObject private var keyboard = KeyboardObserver()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color(Asset.inTechsLeft)
            
            VStack {
                HStack {
                    Text("회원가입")
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
                                Image(system: .person)
                                TextField("이름을 입력하세요", text: $InTechsVM.name)
                                    .textContentType(.emailAddress)
                            }
                            Color.gray.frame(height: 1)
                        }
                        
                        VStack(spacing: 5) {
                            HStack(spacing: 20) {
                                Image(system: .emailFill)
                                TextField("이메일을 입력하세요", text: $InTechsVM.email)
                                    .textContentType(.emailAddress)
                            }
                            Color.gray.frame(height: 1)
                        }
                        
                        VStack(spacing: 5) {
                            HStack(spacing: 20) {
                                Image(system: .lockFill)
                                SecureField("비밀번호를 입력하세요", text: $InTechsVM.password)
                            }
                            Color.gray.frame(height: 1)
                        }
                    }.padding(.vertical, UIFrame.width / 10)
                    
                    Spacer()
                    
                    if InTechsVM.email != "" && InTechsVM.password != "" {
                        Text("회원가입")
                            .foregroundColor(Color(Asset.white))
                            .font(.title2)
                            .fontWeight(.medium)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(Asset.black)).frame(width: UIFrame.width / 1.2))
                            .onTapGesture {
                                self.InTechsVM.apply(.register)
                            }
                            .padding(.vertical, UIFrame.width / 8)
                    } else {
                        Text("회원가입")
                            .foregroundColor(Color(Asset.white))
                            .font(.title2)
                            .fontWeight(.medium)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(Asset.black).opacity(0.3)).frame(width: UIFrame.width / 1.2))
                            .padding(.vertical, UIFrame.width / 8)
                    }
                }.padding()
                .padding(.horizontal)
                
            }.frame(height: keyboard.isKeyboard ? UIFrame.height / 1.3 : UIFrame.height / 1.7)
            .navigationBarTitle("", displayMode: .inline)
            
            if self.InTechsVM.errorMessage != "" {
                ErrorView(message: self.InTechsVM.errorMessage)
                    .onTapGesture {
                        self.InTechsVM.errorMessage = ""
                    }
            }
            
            if self.InTechsVM.isLoading {
                VStack {
                    Spacer()
                    ProgressView()
                        .scaleEffect(x: 1.5, y: 1.5, anchor: .center)
                        .progressViewStyle(CircularProgressViewStyle())
                    Spacer()
                }
            }
            
        }.ignoresSafeArea(edges: .bottom)
            .onAppear {
                self.InTechsVM.successExecute = {
                    withAnimation {
                        self.homeVM.isLogin = true
                    }
                }
            }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
