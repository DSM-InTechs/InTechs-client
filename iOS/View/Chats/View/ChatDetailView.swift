//
//  ChatDetailViewe.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/08/26.
//

import SwiftUI
import Introspect

struct ChatDetailView: View {
    @ObservedObject var chatVM = ChatDetailViewModel()
    @State var uiTabarController: UITabBarController?
    @State private var showInfoView = false
    let title: String
    
    var body: some View {
        ZStack {
            ScrollView {
                LazyVStack {
                    ForEach(0...10, id: \.self) { _ in
                        ChatDetailRow()
                            .padding(.all, 10)
                        
                    }
                }
            }
            
            NavigationLink(destination: ChannelInfoView(),
                           isActive: self.$showInfoView)
            { Text("")
                .hidden()
            }
            
            
            VStack(spacing: 20) {
                Spacer()
                
                VStack {
                    Divider()
                        .frame(width: UIFrame.width)
                    
                    VStack {
                        HStack {
                            Image(system: .clip)
                            TextField("메세지를 입력하세요", text: $chatVM.text)
                            if chatVM.text == "" {
                                Image(system: .paperplane)
                            } else {
                                Image(system: .paperplaneFill)
                            }
                        }.padding(.bottom, 10)
                        
                    }.frame(width: UIFrame.width - 50, height: UIFrame.height / 12)
                }.background(Color(Asset.white))
                
            }.ignoresSafeArea()
            
            .navigationBarTitle(title)
            .navigationBarItems(trailing: Group {
                SystemImage(system: .info).frame(width: 20, height: 20).onTapGesture {
                    self.showInfoView.toggle()
                }
            })
            .introspectTabBarController { (UITabBarController) in
                UITabBarController.tabBar.isHidden = true
                uiTabarController = UITabBarController
            }
        }
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
            }
            HStack(spacing: 10) {
                Circle().frame(width: 40, height: 40)
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(name)
                            .fontWeight(.bold)
                        Spacer()
                        Text(time)
                            .foregroundColor(.gray)
                    }
                    
                    Text(_body)
                }
            }
        }
        
    }
}

struct ChatDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ChatListView()
        ChatDetailView(title: "채널 이름")
    }
}
