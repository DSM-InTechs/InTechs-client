//
//  ChatlistView.swift
//  InTechs Extension
//
//  Created by GoEun Jeong on 2021/09/01.
//

import SwiftUI

struct ChatlistView: View {
    let channels = [ChatRoom]()
    
    var body: some View {
        List {
            ForEach(channels, id: \.self) { channel in
                NavigationLink(destination: ChatDetailView(channel: channel)) {
                    ChatRow(channel: channel)
                        .padding(.all, 10)
                }
            }
        }.listStyle(CarouselListStyle())
    }
}

struct ChatRow: View {
    let channel: ChatRoom
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 10) {
                    if channel.imageURL == "placeholder" {
                        ZStack {
                            Circle()
                                .foregroundColor(.gray.opacity(0.5))
                                .frame(width: 20, height: 20)
                            
                            Text("#")
                                .foregroundColor(.gray)
                        }
                    } else {
                        Circle()
                            .frame(width: 20, height: 20)
                    }
                    
                    Text(channel.name)
                        .fontWeight(.bold)
                        .lineLimit(1)
                }
                HStack {
                    Text(channel.message)
                        .foregroundColor(.gray)
                        .font(.caption2)
                        .lineLimit(1)
                    Spacer()
                }
            }
        }
    }
}

struct ChatlistView_Previews: PreviewProvider {
    static var previews: some View {
        ChatlistView()
    }
}
