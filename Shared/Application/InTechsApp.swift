//
//  InTechsApp.swift
//  Shared
//
//  Created by GoEun Jeong on 2021/08/21.
//

import SwiftUI

@main
struct InTechsApp: App {
    #if os(OSX)
    @ObservedObject var homeViewModel = HomeViewModel()
    #endif
    
    var body: some Scene {
        #if os(iOS)
        WindowGroup {
            ContentView()
        }
        #endif
        
        #if os(OSX)
        WindowGroup {
            ContentView()
                .environmentObject(homeViewModel)
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        WindowGroup("LoginView") {
            LoginView()
                .environmentObject(homeViewModel)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }.handlesExternalEvents(matching: Set(arrayLiteral: "LoginView"))
        .windowStyle(HiddenTitleBarWindowStyle())
        
        WindowGroup("RegisterView") {
            RegisterView()
                .environmentObject(homeViewModel)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }.handlesExternalEvents(matching: Set(arrayLiteral: "RegisterView"))
        .windowStyle(HiddenTitleBarWindowStyle())
        #endif
    }
}
