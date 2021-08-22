//
//  Frame.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/22.
//

#if os(iOS)

import UIKit

public struct UIFrame {
    static let width = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.height
}

#endif

#if os(OSX)

import Cocoa

public struct NSFrame {
    static let width = NSScreen.main!.visibleFrame.width
    static let height = NSScreen.main!.visibleFrame.height
}

#endif
