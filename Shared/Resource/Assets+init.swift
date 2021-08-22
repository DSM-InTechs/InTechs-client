//
//  Colorr+Assets.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/22.
//

import SwiftUI

extension Color {
    init(_ asset: ColorAsset) {
        self.init(asset.color)
    }
}

extension Image {
    init(_ asset: ImageAsset) {
        self.init(asset.name)
    }
}
