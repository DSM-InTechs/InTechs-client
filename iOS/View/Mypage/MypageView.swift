//
//  MypageView.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/08/26.
//

import SwiftUI

struct MypageView: View {
    var body: some View {
        NavigationView {
            Text("Hello, World!")
                .padding()
                .navigationBarTitle("마이페이지", displayMode: .inline)
        }
        
    }
}

struct MypageView_Previews: PreviewProvider {
    static var previews: some View {
        MypageView()
    }
}
