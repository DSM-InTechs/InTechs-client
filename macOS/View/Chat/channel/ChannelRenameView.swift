//
//  ChannelEdit.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/09/01.
//

import SwiftUI

struct ChannelRenameView: View {
    let channel: RoomInfo
    let execute: () -> ()
    
    @EnvironmentObject var homeVM: HomeViewModel
    @ObservedObject var viewModel = ChannelRenameViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("\(channel.name) 채널 수정하기")
                .fontWeight(.bold)
                .font(.title)
            
            TextField("새 이름을 입력하세요.", text: $viewModel.updatedName)
                .padding()
                .textFieldStyle(PlainTextFieldStyle())
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(Asset.black), lineWidth: 1)
                )
            
            HStack {
                Text("취소")
                    .padding(.all, 10)
                    .padding(.horizontal, 10)
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
                
                Text("확인")
                    .foregroundColor(Color(Asset.black))
                    .padding(.all, 10)
                    .padding(.horizontal, 10)
                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.blue))
                    .onTapGesture {
                        viewModel.apply(.change)
                        withAnimation {
                            self.homeVM.toast = nil
                        }
                    }
                    .padding(.top)
            }
        }.padding()
        .padding(.all, 10)
        .onAppear {
            self.viewModel.apply(.getChannel(channel: channel))
        }
    }
}

struct ChannelExitView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    @ObservedObject var viewModel = ChannelExitDeleteViewModel()
    let channel: RoomInfo
    let execute: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("\(channel.name) 채널을 탈퇴하시겠습니까?")
                .fontWeight(.bold)
                .font(.title)
            
            Text("채널을 한 번 탈퇴하면 다시 복구할 수 없습니다.")
            
            HStack(spacing: 15) {
                Spacer()
                Text("취소")
                    .padding(.all, 10)
                    .padding(.horizontal, 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(Asset.black), lineWidth: 1)
                    )
                    .onTapGesture {
                        withAnimation {
                            self.homeVM.toast = nil
                        }
                    }
                
                Text("삭제")
                    .foregroundColor(Color(Asset.black))
                    .padding(.all, 10)
                    .padding(.horizontal, 10)
                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.red))
                    .onTapGesture {
                        viewModel.apply(.exit)
                        withAnimation {
                            self.homeVM.toast = nil
                        }
                        execute()
                    }
            }
        }.padding()
        .padding(.all, 10)
        .onAppear {
            self.viewModel.apply(.getChannel(channel: channel))
        }
    }
}

struct ChannelDeleteView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    @ObservedObject var viewModel = ChannelExitDeleteViewModel()
    
    let channel: RoomInfo
    let execute: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("\(channel.name) 채널을 삭제하시겠습니까?")
                .fontWeight(.bold)
                .font(.title)
            
            Text("채널을 한 번 삭제하면 다시 복구할 수 없습니다.")
            
            HStack(spacing: 15) {
                Spacer()
                Text("취소")
                    .padding(.all, 10)
                    .padding(.horizontal, 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(Asset.black), lineWidth: 1)
                    )
                    .onTapGesture {
                        withAnimation {
                            self.homeVM.toast = nil
                        }
                    }
                
                Text("삭제")
                    .foregroundColor(Color(Asset.black))
                    .padding(.all, 10)
                    .padding(.horizontal, 10)
                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.red))
                    .onTapGesture {
                        self.viewModel.apply(.delete)
                        withAnimation {
                            self.homeVM.toast = nil
                        }
                        execute()
                    }
            }
        }.padding()
        .padding(.all, 10)
        .onAppear {
            self.viewModel.apply(.getChannel(channel: channel))
        }
    }
}

struct MessagelDeleteView: View {
    let execute: () -> Void
    @EnvironmentObject var homeVM: HomeViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("메세지를 삭제하시겠습니까?")
                .fontWeight(.bold)
                .font(.title)
            
            Text("한 번 삭제하면 다시 복구할 수 없습니다.")
            
            HStack(spacing: 15) {
                Spacer()
                Text("취소")
                    .padding(.all, 10)
                    .padding(.horizontal, 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(Asset.black), lineWidth: 1)
                    )
                    .onTapGesture {
                        withAnimation {
                            self.homeVM.toast = nil
                        }
                    }
                
                Text("삭제")
                    .foregroundColor(Color(Asset.black))
                    .padding(.all, 10)
                    .padding(.horizontal, 10)
                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.red))
                    .onTapGesture {
                        withAnimation {
                            self.homeVM.toast = nil
                            self.execute()
                        }
                    }
            }
        }.padding()
        .padding(.all, 10)
    }
}

//struct ChannelEdit_Previews: PreviewProvider {
//    static var previews: some View {
////        ChannelRenameView(execute: {}, channelId: "", name: "")
////        ChannelDeleteView()
//    }
//}
