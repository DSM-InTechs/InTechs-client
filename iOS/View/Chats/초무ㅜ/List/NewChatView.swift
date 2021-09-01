//
//  NewChatView.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/30.
//

import SwiftUI
import Introspect

struct NewChatView: View {
    var body: some View {
        ZStack {
            Color(UIColor.secondarySystemBackground)
                .ignoresSafeArea()
            
            GeometryReader { geo in
                VStack(spacing: 10) {
                    NavigationLink(destination: NewDMView()) {
                        MypageRow(title: "DM", _body: "", image: .person)
                    }
                    
                    NavigationLink(destination: NewChannelListView()) {
                        MypageRow(title: "채널", _body: "", image: .bell)
                    }
                    
                }.padding()
            } .navigationBarTitle("새 채팅")
        }
        .introspectTabBarController { (UITabBarController) in
            UITabBarController.tabBar.isHidden = true
        }
    }
}

struct NewChannelListView: View {
    @State private var isNext: Bool = false
    
    var body: some View {
        VStack(spacing: 10) {
            Group {
                TextField("Search", text: .constant(""))
                    .padding(.all, 10)
                    .background(Color.gray).opacity(0.2).cornerRadius(10)
            }.padding(.vertical, 10)
            
            ScrollView {
                LazyVStack {
                    ForEach(0...1, id: \.self) { _ in
                        // 1:1 채팅으로 네비게이션 필요
                        HStack {
                            Circle().frame(width: 30, height: 30)
                            Text("사람 이름")
                            Spacer()
                            Image(system: .circle)
                        }.padding()
                        Divider()
                    }
                }
            }
            
            NavigationLink(destination: NewChannelView(),
                           isActive: self.$isNext)
                { EmptyView() }
                    .hidden()
        }.padding()
        .navigationBarTitle("새 채널")
        .navigationBarItems(trailing: Text("다음").foregroundColor(.blue).onTapGesture {
            self.isNext = true
        })
    }
}

struct NewChannelView: View {
    @State var pickedImage: Image? = nil
    @State private var isImage = false
    
    var body: some View {
        ZStack {
            Color(UIColor.secondarySystemBackground)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 25) {
                    HStack {
                        Spacer()
                        VStack {
                            // 기본 이미지
                            if pickedImage == nil {
                                Circle().frame(width: UIFrame.width / 4, height:  UIFrame.width / 4)
                                    .foregroundColor(.gray.opacity(0.5))
                            } else {
                                pickedImage!
                                    .resizable()
                                    .frame(width: UIFrame.width / 4, height:  UIFrame.width / 4)
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                            }
                            Text("편집")
                                .foregroundColor(.gray)
                                .font(.caption)
                        }.onTapGesture {
                            self.isImage = true
                        }
                        Spacer()
                    }.sheet(isPresented: $isImage) {
                        ImagePicker(sourceType: .photoLibrary, imagePicked: { image in
                            self.pickedImage = Image(uiImage: image)
                        })
                    }
                    
                    VStack {
                        VStack {
                            TextField("채널 이름", text: .constant(""))
                                .padding(.all, 10)
                        }.background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(Asset.white)))
                    }
                    
                    
                    VStack(alignment: .leading) {
                        Text("멤버 (1)") // 또는 멤버 없음 표시
                            .foregroundColor(.gray)
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.bottom, 5)
                        
                        LazyVStack(spacing: 0) {
                            ForEach(0...1, id: \.self) { _ in
                                HStack {
                                    Circle().frame(width: 30, height: 30)
                                    Text("사람 이름")
                                    Spacer()
                                    Image(system: .xmarkCircle)
                                }.padding()
                                Divider()
                            }.background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(Asset.white)))
                        }
                    }
                }.padding()
                .navigationBarTitle("새 채널")
                .navigationBarItems(trailing: Text("생성").foregroundColor(.blue).onTapGesture {
                    // 채널로 네비게이션
                })
            }
        }
    }
}

struct NewDMView: View {
    var body: some View {
        VStack(spacing: 10) {
            Group {
                TextField("Search", text: .constant(""))
                    .padding(.all, 10)
                    .background(Color.gray).opacity(0.2).cornerRadius(10)
            }.padding(.vertical, 10)
            
            ScrollView {
                LazyVStack {
                    ForEach(0...1, id: \.self) { _ in
                        HStack {
                            Circle().frame(width: 30, height: 30)
                            Text("사람 이름")
                            Spacer()
                        }.padding()
                        Divider()
                    }
                }
            }
        }.padding()
        .navigationBarTitle("새 DM")
    }
}


struct NewChatView_Previews: PreviewProvider {
    static var previews: some View {
        NewChatView()
        NewChannelListView()
        NewChannelView()
        NewDMView()
    }
}
