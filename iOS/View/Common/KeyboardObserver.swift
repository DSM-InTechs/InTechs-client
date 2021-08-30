//
//  KeyboardGuardian.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/29.
//

import SwiftUI
import Combine

final class KeyboardObserver: ObservableObject {
    @Published var isKeyboard: Bool = false
    
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardDidHide(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    func removeObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    init() {
        self.addObserver()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyBoardWillShow(notification: Notification) {
        withAnimation {
            self.isKeyboard = true
        }
    }
    
    @objc func keyBoardDidHide(notification: Notification) {
        withAnimation {
            self.isKeyboard = false
        }
    }
}
