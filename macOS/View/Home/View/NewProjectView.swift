//
//  NewProjectView.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/09/04.
//

import SwiftUI

struct NewProjectView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    @ObservedObject var viewModel = NewProjectViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            VStack(alignment: .leading) {
                Text("새 프로젝트")
                    .font(.title)
                    .fontWeight(.bold)
            }
            
            VStack(alignment: .leading) {
                Text("로고")
                if viewModel.image == nil {
                    RoundedRectangle(cornerRadius: 10).frame(width: 40, height: 40)
                        .onTapGesture {
                            NSOpenPanel.openImage(completion: { result in
                                switch result {
                                case .success(let image):
                                    self.viewModel.image = image.1
                                case .failure(_):
                                    break
                                }
                            })
                        }
                } else {
                    Image(nsImage: viewModel.image!)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .onTapGesture {
                            NSOpenPanel.openImage(completion: { result in
                                switch result {
                                case .success(let image):
                                    self.viewModel.image = image.1
                                case .failure(_):
                                    break
                                }
                            })
                        }
                }
                
            }
            
            VStack(alignment: .leading) {
                Text("이름")
                
                TextField("", text: $viewModel.name)
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
                
                if viewModel.name != "" {
                    Text("생성")
                        .padding(.all, 5)
                        .padding(.horizontal, 10)
                        .font(.title3)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.blue))
                        .onTapGesture {
                            self.viewModel.apply(.createProject)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                                self.homeVM.apply(.onAppear)
                            })
                            withAnimation {
                                self.homeVM.toast = nil
                            }
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
