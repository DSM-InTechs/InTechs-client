//
//  SettingView.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/30.
//

import SwiftUI

struct SettingView: View {
    @State var text: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading) {
                Text("로고")
                HStack {
                    Button(action: {
                        NSOpenPanel.openImage(completion: { _ in
                            
                        })
                    }, label: {
                        RoundedRectangle(cornerRadius: 10).frame(width: 40, height: 40)
                    }).buttonStyle(PlainButtonStyle())
                }
            }
            
            VStack(alignment: .leading) {
                Text("이름")
                TextField("프로젝트 이름", text: $text)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.all, 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(Color.gray.opacity(0.3))
                    )
            }
            
            VStack {
                
            }
            
            MemberPopView()
            
            Spacer()
            
            HStack {
                HStack {
                    Text("삭제")
                        .foregroundColor(.red)
                        .padding(.all, 10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(Color.red)
                        )
                }
                
                Spacer()
                
                HStack {
                    Text("저장")
                        .padding(.all, 10)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.blue))
                }
            }.padding(.top)
        }.padding()
        .padding(.trailing, 70)
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
