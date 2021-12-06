//
//  ChannelSearchView.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/08/23.
//

import SwiftUI
import Kingfisher

struct ChannelSearchView: View {
    let id: String
    @ObservedObject var viewModel = ChannelSearchViewModel()
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                TextField("검색", text: $viewModel.text, onCommit: {
                    self.viewModel.apply(.search)
                })
                    .textFieldStyle(PlainTextFieldStyle())
            }
            
            Divider()
            
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.messages, id: \.self) { message in
                        HStack(spacing: 10) {
                            KFImage(URL(string: message.sender.imageURL))
                                .resizable()
                                .clipShape(Circle())
                                .frame(width: 30, height: 30)
                            
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Text(message.sender.name)
                                        .fontWeight(.bold)
                                    Text(message.time.replacingOccurrences(of: "T", with: "  ").prefix(20).suffix(15))
                                        .foregroundColor(.gray)
                                }
                                
                                Text(message.message)
//                                    .background(Rectangle().foregroundColor(.blue.opacity(0.5)))
                            }
                            
                            Spacer()
                        }.padding(.all, 10)
                    }
                }
            }
        }.padding()
            .padding(.all, 10)
            .onAppear {
                self.viewModel.apply(.onAppear(channelId: id))
            }
    }
}
