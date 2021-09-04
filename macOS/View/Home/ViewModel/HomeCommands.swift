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
                viewModel.selectedTab = HomeTab.chats
            }) {
                Text("1")
            }

            Button(action: {
                viewModel.selectedTab = HomeTab.projects
            }) {
                Text("2")
            }
            
            Button(action: {
                viewModel.selectedTab = HomeTab.projects
            }) {
                Text("3")
            }
            
            Button(action: {
                viewModel.selectedTab = HomeTab.projects
            }) {
                Text("4")
            }
        }
    }
}
