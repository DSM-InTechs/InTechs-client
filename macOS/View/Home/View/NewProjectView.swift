//
//  NewProjectView.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/09/04.
//

import SwiftUI

struct NewProjectView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            VStack(alignment: .leading) {
                Text("새 프로젝트")
                    .font(.title)
                    .fontWeight(.bold)
            }
            
            VStack(alignment: .leading) {
                Text("로고 (선택)")
                RoundedRectangle(cornerRadius: 10).frame(width: 40, height: 40)
            }
            
            VStack(alignment: .leading) {
                Text("이름")
                
                TextField("", text: .constant(""))
                    .font(.title2)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.all, 5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(Asset.black), lineWidth: 1)
                    )
            }
            
            Spacer(minLength: 0)
            
            HStack {
                Text("취소")
                    .padding(.all, 5)
                    .padding(.horizontal, 10)
                    .font(.title3)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(Asset.black), lineWidth: 1)
                    )
                    .onTapGesture {
                        withAnimation {
                            self.homeVM.toast = nil
                        }
                    }
                
                Spacer()
                
                Text("생성")
                    .padding(.all, 5)
                    .padding(.horizontal, 10)
                    .font(.title3)
                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.blue))
                    .onTapGesture {
                        withAnimation {
                            self.homeVM.toast = nil
                        }
                    }
            }
        }.padding()
        .padding(.all, 5)
    }
}

struct NewProjectView_Previews: PreviewProvider {
    static var previews: some View {
        NewProjectView()
    }
}
