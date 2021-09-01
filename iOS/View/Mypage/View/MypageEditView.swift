//
//  MypageEditView.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/26.
//

import SwiftUI

struct MypageEditView: View {
    @State var uiTabarController: UITabBarController?
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
                    
                    VStack(alignment: .leading) {
                        Text("이름")
                            .foregroundColor(.gray)
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.bottom, 5)
                        
                        VStack {
                            TextField("유저 이름", text: .constant(""))
                                .padding(.all, 10)
                        }.background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(Asset.white)))
                    }
                    
                    VStack(alignment: .leading) {
                        Text("연락처") // 또는 멤버 없음 표시
                            .foregroundColor(.gray)
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.bottom, 5)
                        
                        HStack(spacing: 20) {
                            Text("메일")
                                .foregroundColor(.gray)
                            Text("gogo8272@gmail.com")
                            Spacer()
                        }.padding()
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(Asset.white)))
                    }
                }.padding()
                .navigationBarTitle("프로필 편집")
                .navigationBarItems(trailing: Text("완료").foregroundColor(.blue).onTapGesture {
                    //
                })
            }
        }
    }
}

struct MypageEditView_Previews: PreviewProvider {
    static var previews: some View {
        MypageEditView()
    }
}
