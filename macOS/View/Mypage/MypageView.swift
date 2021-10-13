//
//  MypageView.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/08/23.
//

import SwiftUI
import Kingfisher

struct MypageView: View {
    @Binding var viewModel: MypageViewModel
    let projects: [Project] = []
    
    var body: some View {
        GeometryReader { geo in
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    KFImage(URL(string: viewModel.profile.image))
                        .frame(width: geo.size.width / 3, height: geo.size.width / 3)
                    
                    VStack {
                        Text("이메일")
                        Text(viewModel.profile.email)
                    }
                }.frame(width: geo.size.width / 2)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(viewModel.profile.name)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    VStack(alignment: .leading) {
                        Text("내 프로젝트")
                        
                        LazyVStack {
                            ForEach(viewModel.myProjects, id: \.self) { project in
                                HStack {
                                    KFImage(URL(string: project.image))
                                    
                                    Text(project.name)
                                }
                            }
                        }
                    }
                }.frame(width: geo.size.width / 2)
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
        MypageView(viewModel: .constant(MypageViewModel()))
    }
}
