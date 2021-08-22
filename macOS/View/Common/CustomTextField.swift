//
//  CustomTextField.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/08/22.
//

import SwiftUI

struct CustomTextField: NSViewRepresentable {
    class Coordinator: NSObject, NSTextFieldDelegate {
        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }
        
        func control(_ control: NSControl, textShouldBeginEditing fieldEditor: NSText) -> Bool {
            true
        }
        
        func controlTextDidEndEditing(_ obj: Notification) {
            guard let textField = obj.object as? NSTextField
            else { return }

            text = textField.stringValue
        }
    }

    @Binding var text: String
    var placeholder: String

    func makeNSView(context: NSViewRepresentableContext<CustomTextField>) -> NSTextField {
        let textField = NSTextField(frame: .zero)
        textField.delegate = context.coordinator
        textField.placeholderString = placeholder
        return textField
    }

    func makeCoordinator() -> CustomTextField.Coordinator {
        return Coordinator(text: $text)
    }

    func updateNSView(_ nsView: NSTextField, context: NSViewRepresentableContext<CustomTextField>) {
        nsView.stringValue = text
    }
}
