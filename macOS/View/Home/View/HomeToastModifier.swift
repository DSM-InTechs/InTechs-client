//
//  HomeToastModifier.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/09/01.
//

import SwiftUI

struct ToastModiier: ViewModifier {
      
    func body(content: Content) -> some View {
          content
            .cornerRadius(10)
            .background(Color(NSColor.textBackgroundColor))
            .border(Color.gray.opacity(0.75))
            .ignoresSafeArea()
    }
      
}
