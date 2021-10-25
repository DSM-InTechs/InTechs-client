//
//  NewProjectView.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/09/04.
//

import SwiftUI

struct ProjectJoinView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    @ObservedObject var viewModel = ProjectJoinViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            VStack(alignment: .leading) {
                Text("프로젝트 가입")
                    .font(.title)
                    .fontWeight(.bold)
            }
            
            VStack(alignment: .leading) {
                Text("프로젝트 코드 (6자리)")
                
                TextField("", text: $viewModel.number)
                    .font(.title2)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.all, 5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(Asset.black), lineWidth: 1)
                    )
                    .modifier(Shake(animatableData: CGFloat(viewModel.attempts)))
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
                
                if viewModel.number != "" {
                    Text("가입")
                        .padding(.all, 5)
                        .padding(.horizontal, 10)
                        .font(.title3)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.blue))
                        .onTapGesture {
                            self.viewModel.apply(.joinProject)
                        }
                }
            }
        }.padding()
            .padding(.all, 5)
            .onAppear {
                self.viewModel.successExecute = {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        self.homeVM.apply(.onAppear)
                    })
                    withAnimation {
                        self.homeVM.toast = nil
                    }
                }
            }
    }
}

struct ProjectJoinView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectJoinView()
    }
}
