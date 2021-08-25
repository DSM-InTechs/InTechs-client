//
//  LoginView.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/08/24.
//

import SwiftUI

struct LoginView: View {
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 10) {
                HStack(spacing: 10) {
                    Image(system: .emailFill)
                    TextField("Email", text: $email)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(Asset.black), lineWidth: 2)
                    )
                }
                
                HStack(spacing: 10) {
                    Image(system: .lockFill)
                    SecureField("Password", text: $password)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(Asset.black), lineWidth: 2)
                    )
                }
            }
        }
        Text("Hello, World!")
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
