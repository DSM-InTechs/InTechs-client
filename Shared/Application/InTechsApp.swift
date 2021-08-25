//
//  InTechsApp.swift
//  Shared
//
//  Created by GoEun Jeong on 2021/08/21.
//

import SwiftUI

@main
struct InTechsApp: App {
    var body: some Scene {
        #if os(iOS)
        WindowGroup {
            ContentView()
        }
        #endif
        
        #if os(OSX)
        WindowGroup {
            ContentView()
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        WindowGroup {
            LoginView()
        }.handlesExternalEvents(matching: Set(arrayLiteral: "LoginView"))
        .windowStyle(HiddenTitleBarWindowStyle())
        
        WindowGroup {
            RegisterView()
        }.handlesExternalEvents(matching: Set(arrayLiteral: "RegisterView"))
        .windowStyle(HiddenTitleBarWindowStyle())
        #endif
    }
}
