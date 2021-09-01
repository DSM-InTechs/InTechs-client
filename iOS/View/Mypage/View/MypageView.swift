//
//  MypageView.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/08/26.
//

import SwiftUI

struct MypageView: View {
    @Environment(\.openURL) var openURL
    @ObservedObject var mypageVM = MypageViewModel()
    @State private var logoutAlert: Bool = false
    @State var uiTabarController: UITabBarController?
    
    var body: some View {
        ZStack {
            Color(UIColor.secondarySystemBackground)
                .ignoresSafeArea()
            
            GeometryReader { geo in
                VStack(spacing: UIFrame.width / 10) {
                    NavigationLink(destination: MypageEditView()) {
                        HStack {
                            Circle().frame(width: 50, height: 50)
                            VStack(alignment: .leading, spacing: 5) {
                                Text("유저 이름")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(Asset.black))
                                Text("편집")
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                    }.padding(.top)
                    
                    VStack(alignment: .leading, spacing: 3) {
                        Text("설정")
                            .foregroundColor(.gray)
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.bottom, 5)
                        
                        NavigationLink(destination: NotificationView()) {
                            MypageRow(title: "알림", _body: "끔", image: .bell)
                        }
                        
                        NavigationLink(destination: FeedbackView()) {
                            MypageRow(title: "피드백 보내기", _body: "", image: .star)
                        }
                        
                        Button(action: {
                            openURL(URL(string: "https://www.apple.com")!)
                        }, label: {
                            MypageRow(title: "개인 정보 보호", _body: "", image: .checkmarkShield)
                        })
                        
                    }
                    
                    VStack(alignment: .leading, spacing: 3) {
                        Text("프로젝트")
                            .foregroundColor(.gray)
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.bottom, 5)
                        
                        NavigationLink(destination: MyProjectListView()) {
                            MypageRow(title: "프로젝트", _body: "프로젝트 이름", image: .project)
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        MypageRow(title: "로그아웃", _body: "", image: .bell, isRightArrow: false)
                            .foregroundColor(.red)
                            .onTapGesture {
                                self.logoutAlert = true
                            }
                    } .alert(isPresented: $logoutAlert) {
                        Alert(title: Text("로그아웃하시겠습니까?"), primaryButton: .destructive(Text("예"), action: {
                            // Some action
                        }), secondaryButton: .cancel())
                    }
                    
                }.padding()
            }.introspectTabBarController { (UITabBarController) in
                UITabBarController.tabBar.isHidden = true
                self.uiTabarController = UITabBarController
            }.onAppear() {
                self.uiTabarController?.tabBar.isHidden = true
            }
        }
    }
}

struct MypageRow: View {
    let title: String
    let _body: String
    let image: SFImage?
    let isRightArrow: Bool
    
    init(title: String, _body: String, image: SFImage? = nil, isRightArrow: Bool = true) {
        self.title = title
        self._body = _body
        self.image = image
        self.isRightArrow = isRightArrow
    }
    
    var body: some View {
        HStack {
            if image != nil {
                if title == "로그아웃" || title == "채널 나가기" {
                    Image(system: image!)
                        .foregroundColor(.red)
                } else if title == "새 채널" {
                    Text("#")
                        .foregroundColor(Color(Asset.black))
                } else {
                    Image(system: image!)
                        .foregroundColor(Color(Asset.black))
                }
            }
            
            if title == "로그아웃" || title == "채널 나가기" {
                Text(title)
                    .foregroundColor(.red)
            } else {
                Text(title)
                    .foregroundColor(Color(Asset.black))
            }
            
            Spacer()
            
            if _body != "" {
                Text(_body)
                    .foregroundColor(.gray)
            }
            
            if isRightArrow {
                Image(system: .rightArrow)
                    .foregroundColor(.gray)
            }
        }.padding(.all, 18)
        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(Asset.white)))
    }
}

struct MypageView_Previews: PreviewProvider {
    static var previews: some View {
        MypageView()
    }
}
