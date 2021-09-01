//
//  NotificationView.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/30.
//

import SwiftUI

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
    var body: some View {
        ZStack {
            Color(UIColor.secondarySystemBackground)
                .ignoresSafeArea()
            
            GeometryReader { _ in
                ScrollView {
                    VStack(spacing: 10) {
                        HStack(spacing: 15) {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.gray)
                                .frame(width: 40, height: 40)
                            Text("프로젝트 1")
                            Spacer()
                            Image(system: .checkmark)
                        }.padding()
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(Asset.white)))
                        
                        HStack(spacing: 15) {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.gray)
                                .frame(width: 40, height: 40)
                            Text("프로젝트 2")
                            Spacer()
                        }.padding()
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(Asset.white)))
                    }
                }
            }.padding()
        }
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
        MyProjectListView()
    }
}
