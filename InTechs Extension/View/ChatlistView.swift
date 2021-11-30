//
//  ChatlistView.swift
//  InTechs Extension
//
//  Created by GoEun Jeong on 2021/09/01.
//

import SwiftUI

struct ChatlistView: View {
    var body: some View {
//        NavigationView {
            List {
                ForEach(allHomes, id: \.id) { channel in
                    NavigationLink(destination: ChatDetailView(channel: channel)) {
                        ChatRow(channel: channel)
                            .padding(.all, 10)
                    }
                }
            }.listStyle(CarouselListStyle())
//        }
    }
}

struct ChatRow: View {
    let channel: Channel
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 10) {
                    if channel.imageUrl == "placeholder" {
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
                    Text(channel.lastMsg)
                        .foregroundColor(.gray)
                        .font(.caption2)
                        .lineLimit(1)
                    Spacer()
                }
            }
            
            if channel.pendingMsgs != "0" {
                Text(channel.pendingMsgs)
                    .font(.caption2)
                    .padding(.all, 3)
                    .background(Circle().foregroundColor(.blue))
            }
        }
    }
}

struct ChatlistView_Previews: PreviewProvider {
    static var previews: some View {
        ChatlistView()
    }
}
