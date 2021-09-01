//
//  FeedbackView.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/30.
//

import SwiftUI
import StoreKit
import Introspect

struct FeedbackView: View {
    @State private var isBug: Bool = false
    @State private var isFeature: Bool = false
    @ObservedObject var feedbackVM = FeedbackViewModel()
    
    var body: some View {
        ZStack {
            Color(UIColor.secondarySystemBackground)
                .ignoresSafeArea()
            
            GeometryReader { _ in
                VStack(spacing: UIFrame.width / 10) {
                    VStack(alignment: .leading, spacing: 3) {
                        Button(action: {
                            self.isBug = true
                        }, label: {
                            MypageRow(title: "버그 신고", _body: "")
                        })
                        .sheet(isPresented: self.$isBug) {
                            FeedbackModalView(isBug: true, text: $feedbackVM.bugMessage, isModal: $isBug)
                        }
                        
                        Button(action: {
                            self.isFeature = true
                        }, label: {
                            MypageRow(title: "기능 제안", _body: "")
                        })
                        .sheet(isPresented: self.$isFeature) {
                            FeedbackModalView(isBug: false, text: $feedbackVM.featureMessage, isModal: $isFeature)
                        }
                        
                        Button(action: {
                            if let windowScene = UIApplication.shared.windows.first?.windowScene { SKStoreReviewController.requestReview(in: windowScene) }
                        }, label: {
                            MypageRow(title: "InTechs 별점 주기", _body: "")
                        })
                        
                    }
                }.padding()
            }
            .introspectTabBarController { (UITabBarController) in
                UITabBarController.tabBar.isHidden = true
            }
        }
    }
}

struct FeedbackModalView: View {
    let isBug: Bool
    @State private var isAnonymous: Bool = false
    @Binding var text: String
    @Binding var isModal: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.secondarySystemBackground)
                    .ignoresSafeArea()
                
                GeometryReader { _ in
                    VStack(spacing: UIFrame.width / 10) {
                        VStack(alignment: .leading, spacing: 3) {
                            Text("인텍스를 더 발전시켜줄 당신의 의견을 말해주세요.")
                                .foregroundColor(.gray)
                                .padding(.bottom, 5)
                            
                            TextField("내용을 입력해주세요", text: $text)
                                .padding(.all, 15)
                                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(Asset.white)))
                        }
                        
                        MypageToggleRow(title: "익명으로 보내기", _body: "", image: nil, isToggle: $isAnonymous)
                    }.padding()
                }
                .navigationBarTitle(isBug ? "버그 신고" : "기능 제안", displayMode: .inline)
                .navigationBarItems(leading: Text("취소")
                                        .foregroundColor(.red).onTapGesture {
                                            self.isModal.toggle()
                                        }, trailing: Text("보내기")
                                            .foregroundColor(text == "" ? .gray : .black))
            }
        }
    }
}

struct MypageToggleRow: View {
    let title: String
    let _body: String
    let image: SFImage?
    @Binding var isToggle: Bool
    
    var body: some View {
        HStack {
            if image != nil {
                Image(system: image!)
            }
            Text(title)
                .foregroundColor(Color(Asset.black))
            Spacer()
            if _body != "" {
                Text(_body)
                    .foregroundColor(.gray)
            }
            
            Toggle("", isOn: $isToggle)
            
        }.padding(.all, 15)
        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(Asset.white)))
    }
}

struct FeedbackView_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackView()
        FeedbackModalView(isBug: true, text: .constant(""), isModal: .constant(false))
    }
}
