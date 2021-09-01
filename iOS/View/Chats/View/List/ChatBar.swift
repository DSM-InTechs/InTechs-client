//
//  ChatBar.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/08/26.
//

import SwiftUI

struct ChatBar: View {
    @Binding var index: Int
    @Binding var offset: CGFloat
    var animation: Namespace.ID
    var width = UIScreen.main.bounds.width
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button(action: {
                    self.index = 1
                    self.offset = 0
                }, label: {
                    ZStack(alignment: .top) {
                        VStack(spacing: 5) {
                            Image(system: .house)
                                .frame(width: 15, height: 15)
                            Text("홈")
                        }.foregroundColor(Color(Asset.black))
                        
                        VStack {
                            Spacer()
                            
                            if self.index == 1 {
                                Capsule()
                                    .fill(Color(Asset.black))
                                    .frame(height: 4)
                                    .matchedGeometryEffect(id: "capsule", in: animation)
                            } else {
                                Capsule()
                                    .fill(Color.clear)
                                    .frame(height: 4)
                            }
                        }
                    }
                })
                
                Button(action: {
                    self.index = 2
                    self.offset = self.width
                }, label: {
                    ZStack(alignment: .top) {
                        VStack(spacing: 5) {
                            Text("#")
                                .frame(width: 15, height: 15)
                            Text("채널")
                        }.foregroundColor(Color(Asset.black))
                        
                        VStack {
                            Spacer()
                            
                            if self.index == 2 {
                                Capsule()
                                    .fill(Color(Asset.black))
                                    .frame(height: 4)
                                    .matchedGeometryEffect(id: "capsule", in: animation)
                            } else {
                                Capsule()
                                    .fill(Color.clear)
                                    .frame(height: 4)
                            }
                        }
                    }
                })
                
                Button(action: {
                    self.index = 3
                    self.offset = self.width * 2
                }, label: {
                    ZStack(alignment: .top) {
                        VStack(spacing: 5) {
                            Image(system: .DM)
                                .frame(width: 15, height: 15)
                            Text("DM")
                        }.foregroundColor(Color(Asset.black))
                        
                        VStack {
                            Spacer()
                            
                            if self.index == 3 {
                                Capsule()
                                    .fill(Color(Asset.black))
                                    .frame(height: 4)
                                    .matchedGeometryEffect(id: "capsule", in: animation)
                            } else {
                                Capsule()
                                    .fill(Color.clear)
                                    .frame(height: 4)
                            }
                        }
                    }
                })
            }
        }
    }
}

struct ChatBar_Previews: PreviewProvider {
    @Namespace static var animation
    
    static var previews: some View {
        ChatBar(index: .constant(1), offset: .constant( UIScreen.main.bounds.width), animation: animation)
    }
}
