//
//  ProjectViewModel.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/08/22.
//

import Foundation

class ProjectViewModel: ObservableObject {
    @Published var selectedTab: ProjectTab = .dashBoard
}
