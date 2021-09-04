//
//  ChannelSearchView.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/08/23.
//

import SwiftUI

struct ChannelSearchView: View {
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("채널 이름")
                    .padding(.all, 5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
                
                TextField("검색", text: .constant(""))
                    .textFieldStyle(PlainTextFieldStyle())
            }
            
            Divider()
            
            ScrollView {
                LazyVStack {
                    ForEach(0...0, id: \.self) { _ in
                        HStack(spacing: 10) {
                            Circle().frame(width: 30, height: 30)
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Text("이름")
                                        .fontWeight(.bold)
                                    Text("9월 29일 03:13")
                                        .foregroundColor(.gray)
                                }
                                
                                Text("채팅 내용")
                                    .background(Rectangle().foregroundColor(.blue.opacity(0.5)))
                            }
                            
                            Spacer()
                        }.padding(.all, 10)
                    }
                }
            }
        }.padding()
        .padding(.all, 10)
    }
}

struct ChannelSearchView_Previews: PreviewProvider {
    static var previews: some View {
        ChannelSearchView()
    }
}
