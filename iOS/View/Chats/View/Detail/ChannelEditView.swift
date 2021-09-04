//
//  ChannelEditView.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/31.
//

import SwiftUI

struct ChannelEditView: View {
    @State var pickedImage: Image?
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
                                Circle().frame(width: UIFrame.width / 4, height: UIFrame.width / 4)
                                    .foregroundColor(.gray.opacity(0.5))
                            } else {
                                pickedImage!
                                    .resizable()
                                    .frame(width: UIFrame.width / 4, height: UIFrame.width / 4)
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
                }.padding()
                .navigationBarTitle("채널 수정")
                .navigationBarItems(trailing: Text("확인").foregroundColor(.blue).onTapGesture {
                    // 채널로 네비게이션
                })
            }
        }
    }
}

struct ChannelEditView_Previews: PreviewProvider {
    static var previews: some View {
        ChannelEditView()
    }
}
