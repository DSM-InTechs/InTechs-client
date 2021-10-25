//
//  MypageView.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/08/23.
//

import SwiftUI
import Kingfisher

struct MypageView: View {
    @ObservedObject var viewModel = MypageViewModel()
    @EnvironmentObject var homeVM: HomeViewModel
    let projects: [Project] = []
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading) {
                Text("마이페이지")
                    .font(.title)
                
                HStack(alignment: .top, spacing: 20) {
                    VStack(alignment: .leading) {
                        Button(action: {
                            NSOpenPanel.openImage(completion: { result in
                                switch result {
                                case .success(let image):
                                    viewModel.updatedImage = image
                                case .failure(_):
                                    break
                                }
                            })
                        }, label: {
                            if viewModel.updatedImage != nil {
                                Image(nsImage: viewModel.updatedImage!)
                                    .resizable()
                                    .frame(width: geo.size.width / 3, height: geo.size.width / 3)
                            } else {
                                KFImage(URL(string: viewModel.profile.image))
                                    .resizable()
                                    .frame(width: geo.size.width / 3, height: geo.size.width / 3)
                            }
                        }).buttonStyle(PlainButtonStyle())
                       
                        VStack(alignment: .leading, spacing: 5) {
                            Text("이메일")
                            Text(viewModel.profile.email)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        VStack(alignment: .leading) {
                            Text("이름")
                            TextField("이름", text: $viewModel.updatedName)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding(.all, 10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .strokeBorder(Color.gray.opacity(0.3))
                                )
                        }
                        
                        VStack(alignment: .leading) {
                            Text("내 프로젝트")
                            
                            LazyVStack {
                                ForEach(viewModel.myProjects, id: \.self) { project in
                                    HStack {
                                        KFImage(URL(string: project.image))
                                            .resizable()
                                            .frame(width: 25, height: 25)
                                        
                                        Text(project.name)
                                        
                                        Spacer()
                                        
                                        if viewModel.currentProject == project.id {
                                            Image(system: .checkmark)
                                        }
                                    }.onTapGesture {
                                        viewModel.currentProject = project.id
                                    }
                                }.foregroundColor(.secondary)
                                    .padding(.all, 10)
                                    .background(RoundedRectangle(cornerRadius: 5).foregroundColor(.gray.opacity(0.1)))
                                    .border(Color.gray.opacity(0.3), width: 1)
                            }
                        }
                        
                        Spacer()
                        
                        HStack {
                            HStack {
                                Text("탈퇴")
                                    .foregroundColor(.red)
                                    .padding(.all, 10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .strokeBorder(Color.red)
                                    )
                            }.onTapGesture {
                                self.homeVM.toast = .userDelete(execute: {
                                    self.viewModel.apply(.deleteUser)
                                })
                            }
                            
                            Spacer()
                            
                            Text("저장")
                                .padding(.all, 10)
                                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.blue))
                        }.onTapGesture {
                            self.viewModel.apply(.change)
                        }
                    }
                }
            }.padding()
        }.padding(.trailing, 70)
            .background(Color(NSColor.textBackgroundColor)).ignoresSafeArea()
            .onAppear {
                self.viewModel.apply(.mypage)
            }
    }
}

struct MypageView_Previews: PreviewProvider {
    static var previews: some View {
        MypageView()
    }
}

struct UserDeleteView: View {
    let execute: () -> Void
    @EnvironmentObject var homeVM: HomeViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("회원탈퇴하시겠습니까?")
                .fontWeight(.bold)
                .font(.title)
            
            HStack(spacing: 15) {
                Spacer()
                Text("취소")
                    .padding(.all, 10)
                    .padding(.horizontal, 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(Asset.black), lineWidth: 1)
                    )
                    .onTapGesture {
                        withAnimation {
                            self.homeVM.toast = nil
                        }
                    }
                
                Text("탈퇴")
                    .foregroundColor(Color(Asset.black))
                    .padding(.all, 10)
                    .padding(.horizontal, 10)
                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.red))
                    .onTapGesture {
                        self.execute()
                        withAnimation {
                            self.homeVM.toast = nil
                            self.homeVM.isLogin = false
                        }
                    }
            }
        }.padding()
        .padding(.all, 10)
    }
}
