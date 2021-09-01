//
//  ChatDetailView.swift
//  InTechs Extension
//
//  Created by GoEun Jeong on 2021/09/01.
//

import SwiftUI

struct ChatDetailView: View {
    var body: some View {
        List {
            ForEach(0...10, id: \.self) { _ in
                // 스레드 있으면 스레드뷰 이동
                ChatDetailRow()
                    .padding(.all, 10)
                
            }
        }.listStyle(CarouselListStyle())
        .navigationTitle("")
    }
}

struct ChatDetailRow: View {
    let name: String = "유저 이름"
    let _body: String = "채팅 메세지"
    let time: String = "09:04"
    let date: String = "8월 28일"
    
    var body: some View {
        VStack {
            if date != "" {
                Text(date)
                    .foregroundColor(.gray)
                    .font(.caption2)
            }
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

struct ChatDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ChatDetailView()
    }
}
