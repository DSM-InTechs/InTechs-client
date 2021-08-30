//
//  FeedbackViewModel.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/30.
//

import SwiftUI

class FeedbackViewModel: ObservableObject {
    @Published var bugMessage: String = ""
    @Published var featureMessage: String = ""
}
