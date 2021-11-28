//
//  ChatlistViewModel.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/30.
//

import SwiftUI

class ChatlistViewModel: ObservableObject {
    @Published var homes: [Channel] = allHomes
    
    @Published var DMs: [Channel] = allDMs
    
    @Published var channels: [Channel] = allChannels
}
