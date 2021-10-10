//
//  ErrorView.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/10/06.
//

import SwiftUI

struct ErrorView: View {
    let message: String
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.black.opacity(0.5)
                
                Text(message)
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                    .font(.title2)
                    .padding()
                    .padding(.all, 10)
                    .background( RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.white))
                    .frame(maxWidth: geo.size.width, maxHeight: geo.size.height)
            }
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(message: "인터넷에 연결되어 있지 않습니다.")
    }
}
