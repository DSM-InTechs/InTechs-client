//
//  NewChannelView.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/09/01.
//

import SwiftUI

struct NewChannelView: View {
    let isDM: Bool
    let execute: () -> Void
    @EnvironmentObject var homeVM: HomeViewModel
    @ObservedObject var viewModel = NewChannelViewModel()
    
    var body: some View {
        if isDM {
            VStack(alignment: .leading, spacing: 30) {
                VStack(alignment: .leading) {
                    Text("DM 생성하기")
                        .font(.title)
                        .fontWeight(.bold)
                }
                
                TextField("대상자 이메일", text: $viewModel.userEmail)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(Color.gray.opacity(0.3))
                    )
                
                Spacer(minLength: 0)
                
                HStack {
                    Text("취소")
                        .padding(.all, 5)
                        .padding(.horizontal, 10)
                        .font(.title3)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(Asset.black), lineWidth: 1)
                        )
                        .onTapGesture {
                            withAnimation {
                                self.homeVM.toast = nil
                            }
                        }
                    
                    Spacer()
                    
                    Text("생성")
                        .padding(.all, 5)
                        .padding(.horizontal, 10)
                        .font(.title3)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.blue))
                        .onTapGesture {
                            self.viewModel.apply(.dm)
                            withAnimation {
                                self.homeVM.toast = nil
                            }
                            self.execute()
                        }
                }
            }.padding()
                .padding(.all, 5)
        } else {
            VStack(alignment: .leading, spacing: 30) {
                VStack(alignment: .leading) {
                    Text("새 채널")
                        .font(.title)
                        .fontWeight(.bold)
                }
                
                VStack(alignment: .leading) {
                    Text("이름")
                    
                    TextField("", text: $viewModel.name)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.all, 10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(Asset.black), lineWidth: 1)
                        )
                }
                
                //            VStack(alignment: .leading) {
                //                Text("멤버")
                //
                //                HStack {
                //                    TextField("이름을 입력하세요.", text: .constant(""))
                //                        .textFieldStyle(PlainTextFieldStyle())
                //                        .padding(.all, 10)
                //                        .overlay(
                //                            RoundedRectangle(cornerRadius: 10)
                //                                .stroke(Color(Asset.black), lineWidth: 1)
                //                        )
                //                }
                //
                //                // ScrollView...
                //
                //            }
                
                Spacer(minLength: 0)
                
                HStack {
                    Text("취소")
                        .padding(.all, 5)
                        .padding(.horizontal, 10)
                        .font(.title3)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(Asset.black), lineWidth: 1)
                        )
                        .onTapGesture {
                            withAnimation {
                                self.homeVM.toast = nil
                            }
                        }
                    
                    Spacer()
                    
                    Text("생성")
                        .padding(.all, 5)
                        .padding(.horizontal, 10)
                        .font(.title3)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.blue))
                        .onTapGesture {
                            self.viewModel.apply(.channel)
                            
                            withAnimation {
                                self.homeVM.toast = nil
                            }
                            self.execute()
                        }
                }
            }.padding()
                .padding(.all, 5)
        }
    }
}

//struct NewChannelView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewChannelView(execute: {})
//    }
//}
