//
//  ChatTab.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/08/22.
//

import SwiftUI

enum ChatTab: String {
    case home = "홈"
    case channels = "채널"
    case DMs = "DM"
}

extension ChatTab {
    func getImage() -> String {
        switch self {
        case .home:
            return "house.fill"
        case .channels:
            return "#"
        case .DMs:
            return "envelope.fill"
        }
    }
}

struct ChatTabButton: View {
    @State private var hover = false
    
    var animation: Namespace.ID
    var tab: ChatTab
    @Binding var selectedTab: ChatTab
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                if tab.getImage() != "#" {
                    if tab == selectedTab {
                        Image(systemName: tab.getImage())
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding(.bottom, 5)
                    } else {
                        Image(systemName: tab.getImage())
                            .font(.title3)
                            .foregroundColor(.gray)
                            .padding(.bottom, 5)
                    }
                    
                } else {
                    if tab == selectedTab || hover {
                        Text("#")
                            .font(.title3)
                            .foregroundColor(.white)
                    } else {
                        Text("#")
                            .font(.title3)
                            .foregroundColor(.gray)
                    }
                }
                if tab == selectedTab {
                    Text(tab.rawValue)
                        .foregroundColor(.white)
                        .padding(.bottom, 5)
                    
                    Color.white
                        .frame(height: 4)
                        .opacity(1.0)
                        .matchedGeometryEffect(id: "opacity", in: animation)
                } else {
                    Text(tab.rawValue)
                        .foregroundColor(.gray)
                        .padding(.bottom, 5)
                    
                    Color.white
                        .frame(height: 4)
                        .opacity(0.0)
                }
            }.foregroundColor(hover ? .accentColor : .gray)
            
        }.frame(width: 60, height: 35)
        
    }
}
