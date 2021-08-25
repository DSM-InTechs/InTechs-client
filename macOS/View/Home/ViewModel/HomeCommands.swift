//
//  HomeCommands.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/08/22.
//

import SwiftUI

struct HomeCommands: Commands {
    @ObservedObject var viewModel: HomeViewModel

    @CommandsBuilder var body: some Commands {
        CommandMenu("Window") {
            Button(action: {
                viewModel.selectedTab = HomeTab.Chats
            }) {
                Text("1")
            }

            Button(action: {
                viewModel.selectedTab = HomeTab.Projects
            }) {
                Text("2")
            }
            
            Button(action: {
                viewModel.selectedTab = HomeTab.Projects
            }) {
                Text("3")
            }
            
            Button(action: {
                viewModel.selectedTab = HomeTab.Projects
            }) {
                Text("4")
            }
        }
    }
}
