//
//  Image+SFImage.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/22.
//

import SwiftUI

extension Image {
    init(system: SFImage) {
        self.init(systemName: system.rawValue)
    }
}

struct SystemImage: View {
    var system: SFImage
    var body: some View {
        Image(system: system)
            .resizable()
    }
}
