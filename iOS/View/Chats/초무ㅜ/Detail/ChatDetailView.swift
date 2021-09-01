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
    @State var fileSheet = false
    @State var isFile = false
    @State var isImage = false
    @State var isSearch = false
    @State private var document: InputDoument = InputDoument(input: "")
    
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
            { EmptyView() }
                .hidden()
            
            if isSearch {
                VStack {
                    SearchBar(text: .constant(""))
                    ScrollView {
                        LazyVStack {
                            ForEach(0...10, id: \.self) { _ in
                                ChatDetailRow()
                                    .padding(.all, 10)
                                
                            }
                        }
                    }
                }.background(Color(Asset.white))
            }
            
            
            VStack(spacing: 20) {
                Spacer()
                
                VStack {
                    Divider()
                        .frame(width: UIFrame.width)
                    
                    VStack {
                        HStack {
                            Image(system: .clip)
                                .onTapGesture {
                                    self.fileSheet = true
                                }
                            TextField("메세지를 입력하세요", text: $chatVM.text)
                            //                            Text(document.input)
                            if chatVM.text == "" {
                                Image(system: .paperplane)
                            } else {
                                Image(system: .paperplaneFill)
                            }
                        }.padding(.bottom, 10)
                        .actionSheet(isPresented: $fileSheet) {
                            ActionSheet(title: Text("사진 또는 파일을 첨부하세요"), buttons: [.default(Text("Photo")) {
                                self.isImage = true
                            }, .default(Text("File")) {
                                self.isFile = true
                            }, .cancel(Text("Cancel"))])
                        }
                        .sheet(isPresented: $isImage) {
                            ImagePicker(sourceType: .photoLibrary, imagePicked: { image in
                                
                            })
                        }
                        .fileImporter(
                            isPresented: $isFile,
                            allowedContentTypes: [.plainText],
                            allowsMultipleSelection: false
                        ) { result in
                            do {
                                guard let selectedFile: URL = try result.get().first else { return }
                                if selectedFile.startAccessingSecurityScopedResource() {
                                    guard let input = String(data: try Data(contentsOf: selectedFile), encoding: .utf8) else { return }
                                    defer { selectedFile.stopAccessingSecurityScopedResource() }
                                    document.input = input
                                } else {
                                    // Handle denied access
                                }
                            } catch {
                                // Handle failure.
                                print("Unable to read file contents")
                                print(error.localizedDescription)
                            }
                        }
                        
                    }.frame(width: UIFrame.width - 50, height: UIFrame.height / 12)
                }.background(Color(Asset.white))
                
            }.ignoresSafeArea()
            
            .navigationBarTitle(title)
            .navigationBarItems(trailing: HStack(spacing: 15) {
                SystemImage(system: .search)
                    .font(.title3)
                    .foregroundColor(.blue)
                    .onTapGesture {
                        withAnimation {
                            self.isSearch = true
                        }
                    }
                
                SystemImage(system: .info)
                    .frame(width: 20, height: 20)
                    .foregroundColor(.blue)
                    .onTapGesture {
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
