//
//  IsActiveView.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/08/23.
//

import SwiftUI

struct ActiveView: View {
    var body: some View {
        Circle().frame(width: 12, height: 12).foregroundColor(.green.opacity(0.9))
            .offset(x: 2, y: 2)
    }
}

struct InActiveView: View {
    var body: some View {
        Circle().frame(width: 12, height: 12).foregroundColor(.gray)
            .offset(x: 2, y: 2)
    }
}
