//
//  ChatlistView.swift
//  InTechs Extension
//
//  Created by GoEun Jeong on 2021/09/01.
//

import SwiftUI

struct ChatlistView: View {
    var body: some View {
        NavigationView {
            List {
                ForEach(0...6, id: \.self) { _ in
                    NavigationLink(destination: ChatDetailView()) {
                        ChatRow()
                            .padding(.all, 10)
                    }
                }
            }.listStyle(CarouselListStyle())
        }
    }
}

struct ChatRow: View {
    let title: String = "채널 이름"
    let image: String = ""
    let lastMsg: String = "마지막 메세지"
    let time: String = "8월 26일"
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 10) {
                    Circle()
                        .frame(width: 20, height: 20)
                    Text(title)
                        .fontWeight(.bold)
                        .lineLimit(1)
                }
                HStack {
                    Text(lastMsg)
                        .foregroundColor(.gray)
                        .font(.caption2)
                        .lineLimit(1)
                    Spacer()
                }
            }
            Text("2")
                .font(.caption2)
                .padding(.all, 3)
                .background(Circle().foregroundColor(.blue))
        }
    }
}

struct ChatlistView_Previews: PreviewProvider {
    static var previews: some View {
        ChatlistView()
    }
}
