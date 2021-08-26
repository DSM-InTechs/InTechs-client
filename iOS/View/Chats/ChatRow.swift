//
//  ChatRow.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/08/26.
//

import SwiftUI

struct ChatRow: View {
    let title: String = "채널 이름"
    let image: String = ""
    let lastMsg: String = "마지막 메세지"
    let time: String = "8월 26일"
    
    var body: some View {
        HStack(spacing: 12) {
            Circle().foregroundColor(.gray).frame(width: UIFrame.width / 8, height: UIFrame.width / 8)
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(title)
                        .fontWeight(.bold)
                    Spacer()
                    Text(time)
                        .foregroundColor(.gray)
                }
               Text(lastMsg)
                .foregroundColor(.gray)
                
                Divider()
            }
        }
    }
}

struct ChatRow_Previews: PreviewProvider {
    static var previews: some View {
        ChatRow()
    }
}
