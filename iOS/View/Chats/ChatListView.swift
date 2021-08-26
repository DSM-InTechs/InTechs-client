//
//  ChatListView.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/22.
//

import SwiftUI

struct ChatListView: View {
    
    init() {
        UINavigationBar.appearance().barTintColor = Asset.white.color
    }
    
    @State private var index = 1
    @State var offset: CGFloat = 0
    @Namespace private var animation
    var width = UIScreen.main.bounds.width
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                HStack {
                    VStack(alignment: .leading, spacing: -1) {
                        ChatBar(index: self.$index, offset: self.$offset, animation: animation)
                            .frame(width: UIFrame.width / 1.85, height: UIFrame.width / 7.5)
                        
                        Divider()
                    }
                    
                    Spacer()
                }
                
                
                GeometryReader { geo in
                    HStack(spacing: 0) {
                        // First View
                        VStack {
                            LazyVStack {
                                ForEach(0...6, id: \.self) { _ in
                                    ChatRow()
                                        .padding(.all, 10)
                                }
                            }
                            Spacer(minLength: 0)
                        }
                        .frame(width: geo.frame(in: .global).width)
                        
                        // Second View
                        VStack {
                            LazyVStack {
                                ForEach(0...6, id: \.self) { _ in
                                    ChatRow()
                                        .padding(.all, 10)
                                }
                            }
                            Spacer(minLength: 0)
                        }
                        .frame(width: geo.frame(in: .global).width)
                        
                        // Third View
                        VStack {
                            LazyVStack {
                                ForEach(0...6, id: \.self) { _ in
                                    ChatRow()
                                        .padding(.all, 10)
                                }
                            }
                            Spacer(minLength: 0)
                        }
                        .frame(width: geo.frame(in: .global).width)
                    }.offset(x: -self.offset)
                    .highPriorityGesture(DragGesture()
                                            .onEnded({ value in
                                                if value.translation.width > 50 {
                                                    changeView(left: false)
                                                }
                                                if -value.translation.width > 50 {
                                                    changeView(left: true)
                                                }
                                            }))
                    
                }
            }
            .animation(.default)
            .padding(.vertical)
            .ignoresSafeArea(edges: .bottom)
            .navigationBarTitle("채팅", displayMode: .inline)
            .navigationBarItems(trailing:
                                    HStack(spacing: 15) {
                                        Button(action: {}, label: {
                                            SystemImage(system: .search)
                                                .font(.title3)
                                                .foregroundColor(.blue)
                                        })
                                        
                                        Button(action: {}, label: {
                                            SystemImage(system: .plus)
                                                .font(.title3)
                                                .foregroundColor(.blue)
                                        })
                                        
                                    })
        }
    }
    
    func changeView(left: Bool) {
        if left {
            if self.index != 3 {
                self.index += 1
            }
        } else {
            if self.index != 0 {
                self.index -= 1
            }
        }
        if self.index == 1 {
            self.offset = 0
        } else if self.index == 2 {
            self.offset = self.width
        } else {
            self.offset = self.width * 2
        }
    }
    
}

struct ChatListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatListView()
    }
}
