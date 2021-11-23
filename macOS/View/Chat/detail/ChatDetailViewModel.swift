//
//  ChatDetailViewModel.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/09/03.
//

import SwiftUI

class ChatDetailViewModel: ObservableObject {
    @Published var text: String = ""
    @Published var editingText: String = ""
    
    @Published var selectedNSImages: [NSImage] = []
    @Published var selectedFile: [NSImage] = []
}
