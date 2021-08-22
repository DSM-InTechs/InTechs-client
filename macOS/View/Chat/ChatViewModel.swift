//
//  ChatViewModel.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/22.
//

import SwiftUI

class ChatViewModel: ObservableObject {
    @Published var selectedTab: ChatTab = .Home
}
