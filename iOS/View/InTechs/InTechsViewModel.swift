//
//  InTechsViewModel.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/29.
//

import SwiftUI

class InTechsViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var pickedImage: Image? = nil
    @Published var attempts: Int = 1
    
    func login() -> Bool {
        // API
        self.email = ""
        self.password = ""
        return true
    }
    
    func register() -> Bool {
        // API
        self.email = ""
        self.password = ""
        // Failed
        withAnimation(.default) {
            self.attempts += 1
        }
        return false
    }
    
}
