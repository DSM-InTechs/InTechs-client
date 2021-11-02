//
//  NotificationView.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/30.
//

import SwiftUI
import Kingfisher

struct NotificationView: View {
    var body: some View {
        ZStack {
            Color(UIColor.secondarySystemBackground)
                .ignoresSafeArea()
            
            GeometryReader { _ in
                VStack(spacing: UIFrame.width / 10) {
                    VStack(alignment: .leading, spacing: 10) {
                        Button(action: {
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                        }, label: {
                            MypageRow(title: "알림", _body: "", image: .bell)
                        })
                        
                        Text("이 앱은 인텍스에서 푸시 알람을 보내도록 설정되지 않았습니다. 설정 > 알림 > InTechs에서 푸시알림을 설정할 수 있습니다.")
                            .foregroundColor(.gray)
                            .padding(.trailing)
                    }
                }.padding()
            }
        }
    }
}

struct MyProjectListView: View {
    @EnvironmentObject private var mypageVM: MypageViewModel
    
    var body: some View {
        ZStack {
            Color(UIColor.secondarySystemBackground)
                .ignoresSafeArea()
            
            GeometryReader { _ in
                ScrollView {
                    LazyVStack {
                        ForEach(mypageVM.myProjects, id: \.self) { project in
                            HStack(spacing: 15) {
                                KFImage(URL(string: project.image))
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                Text(project.name)
                                Spacer()
                                if project.id == mypageVM.currentProject {
                                    Image(system: .checkmark)
                                }
                                
                            }.padding()
                                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(Asset.white)))
                                .onTapGesture {
                                    mypageVM.currentProject = project.id
                                }
                        }
                    }
                }
            }.padding()
        }.onAppear {
            self.mypageVM.apply(.getProjects)
        }
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
        MyProjectListView().environmentObject(MypageViewModel())
    }
}
