//
//  NotificationView.swift
//  InTechs Extension
//
//  Created by GoEun Jeong on 2021/09/01.
//

import SwiftUI

struct NotificationView: View {
    let name: String = "유저 이름"
    let _body: String = "채팅 메세지"
    let time: String = "09:04"
    
    var body: some View {
        VStack {
            HStack(spacing: 5) {
                VStack(alignment: .leading) {
                    HStack {
                        Circle()
                            .frame(width: 20, height: 20)
                        Text(name)
                            .fontWeight(.bold)
                            .lineLimit(1)
                        Spacer(minLength: 0)
                        Text(time)
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                    
                    Text(_body)
                        .font(.caption2)
                }
            }
        }
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
