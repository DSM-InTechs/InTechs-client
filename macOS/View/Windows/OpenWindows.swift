//
//  OpenWindows.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/08/24.
//

import SwiftUI

enum OpenWindows: String, CaseIterable {
    case LoginView = "LoginView"
    case RegisterView   = "RegisterView"
    //As many views as you need.

    func open(){
        if let url = URL(string: "InTechs://\(self.rawValue)") { //replace myapp with your app's name
            NSWorkspace.shared.open(url)
        }
    }
}
