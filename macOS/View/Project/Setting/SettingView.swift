//
//  SettingView.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/30.
//

import SwiftUI
import Kingfisher

struct SettingView: View {
    @State var text: String = ""
    @EnvironmentObject var homeVM: HomeViewModel
    @EnvironmentObject var projectlistVM: ProjectViewModel
    @StateObject var viewModel = SettingViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading) {
                Text("로고")
                HStack {
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
                                .frame(width: 40, height: 40)
                        } else {
                            KFImage(URL(string: viewModel.projectInfo.image.imageUrl))
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                    }).buttonStyle(PlainButtonStyle())
                }
            }
            
            VStack(alignment: .leading) {
                Text("이름")
                TextField("프로젝트 이름", text: $viewModel.updatedName)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.all, 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(Color.gray.opacity(0.3))
                    )
            }
            
            MemberPopView(number: Array(String(viewModel.currentProject)))
            
            Spacer()
            
            HStack {
                HStack {
                    Text("탈퇴")
                        .foregroundColor(Color.white)
                        .padding(.all, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color.red)
                        )
                }.onTapGesture {
                    self.homeVM.toast = .projectExit(execute: {
                        self.viewModel.apply(.exit)
                    })
                }
                
                HStack {
                    Text("삭제")
                        .foregroundColor(.red)
                        .padding(.all, 10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(Color.red)
                        )
                }.onTapGesture {
                    self.homeVM.toast = .projectDelete(execute: {
                        self.viewModel.apply(.delete)
                    })
                }
                
                Spacer()
                
                HStack {
                    Text("저장")
                        .padding(.all, 10)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.blue))
                }.onTapGesture {
                    self.viewModel.apply(.change)
                    self.projectlistVM.apply(.onAppear)
                }
                
            }.padding(.top)
        }.padding()
        .padding(.trailing, 70)
        .onAppear {
            self.viewModel.apply(.onAppear)
            self.viewModel.refreshProject = {
                self.homeVM.apply(.onAppear)
            }
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
        ProjectDeleteView(execute: { })
    }
}

struct ProjectExitView: View {
    let execute: () -> Void
    @EnvironmentObject var homeVM: HomeViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("프로젝트를 탈퇴하시겠습니까?")
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
                        self.homeVM.apply(.onAppear)
                        withAnimation {
                            self.homeVM.toast = nil
                        }
                    }
            }
        }.padding()
        .padding(.all, 10)
    }
}

struct ProjectDeleteView: View {
    let execute: () -> Void
    @EnvironmentObject var homeVM: HomeViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("프로젝트를 삭제하시겠습니까?")
                .fontWeight(.bold)
                .font(.title)
            
            Text("한 번 삭제하면 다시 복구할 수 없습니다.")
            
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
                
                Text("삭제")
                    .foregroundColor(Color(Asset.black))
                    .padding(.all, 10)
                    .padding(.horizontal, 10)
                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.red))
                    .onTapGesture {
                        self.execute()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                            self.homeVM.apply(.onAppear)
                        })
                        withAnimation {
                            self.homeVM.toast = nil
                        }
                    }
            }
        }.padding()
        .padding(.all, 10)
    }
}
