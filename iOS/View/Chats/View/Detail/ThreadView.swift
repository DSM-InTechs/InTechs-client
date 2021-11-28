//
//  ThreadView.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/09/01.
//

import SwiftUI

struct ThreadView: View {
    var body: some View {
        VStack {
//            ChatRow(channel: <#Channel#>)
            
            HStack(spacing: 10) {
                Color.gray.frame(height: 1)
                
                Text("4개의 답글")
                
                Color.gray.frame(height: 1)
            }
            
            ScrollView {
                LazyVStack {
                    ForEach(0...3, id: \.self) { _ in
//                        ChatRow(channel: <#Channel#>)
                    }
                }
            }
            
        }.padding()
        .navigationTitle("유저: 메세지 이름")
    }
}

struct ThreadView_Previews: PreviewProvider {
    static var previews: some View {
        ThreadView()
    }
}
