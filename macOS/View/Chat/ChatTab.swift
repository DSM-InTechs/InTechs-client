//
//  ChatTab.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/08/22.
//

import SwiftUI

enum ChatTab: String {
    case Home
    case Channels
    case DMs
}

extension ChatTab {
    func getImage() -> String {
        switch self {
        case .Home:
            return "house.fill"
        case .Channels:
            return "#"
        case .DMs:
            return "person.crop.circle.fill"
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
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                    } else {
                        Image(systemName: tab.getImage())
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.gray)
                    }
                    
                } else {
                    if tab == selectedTab || hover {
                        Text("#")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                    } else {
                        Text("#")
                            .font(.system(size: 18))
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
