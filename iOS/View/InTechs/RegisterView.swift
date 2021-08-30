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
    
    @State private var showImagePicker: Bool = false
    
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
                
                ZStack {
                    if InTechsVM.pickedImage == nil {
                        Circle().frame(width: UIFrame.width / 2.5, height: UIFrame.height / 5)
                            .foregroundColor(Color(UIColor.systemGray2))
                    } else {
                        InTechsVM.pickedImage!
                            .resizable()
                            .frame(width: UIFrame.width / 2, height: UIFrame.height / 4)
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                    }
                    
                    Image(system: .camera)
                        .font(.title)
                        .foregroundColor(.white)
                }.onTapGesture {
                    self.showImagePicker.toggle()
                }
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
                    
                    if InTechsVM.email != "" && InTechsVM.password != "" && InTechsVM.pickedImage != nil {
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
                            .padding(.vertical, UIFrame.width / 8)
                            .onTapGesture {
                                if self.InTechsVM.register() {
                                    withAnimation {
                                        self.homeVM.isLogin = true
                                    }
                                }
                            }
                    } else {
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
                            .opacity(0.3)
                            .padding(.vertical, UIFrame.width / 8)
                            .modifier(Shake(animatableData: CGFloat(InTechsVM.attempts)))
                    }
                    
                }.padding()
                .padding(.horizontal)
            }.frame(height: keyboard.isKeyboard ? UIFrame.height / 1.7 : UIFrame.height / 2)
            .navigationBarTitle("", displayMode: .inline)
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(sourceType: .photoLibrary) { image in
                    InTechsVM.pickedImage = Image(uiImage: image)
                }
            }
        } .ignoresSafeArea(edges: .bottom)
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
