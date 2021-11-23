//
//  NSSavePanel.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/11/23.
//

import Foundation
import AppKit

extension NSSavePanel {
    
    // 저장 실패 시 사용
    enum SaveError: Error {
        case saveFailed
    }
    
    static func saveFile(fileName: String, targetPath: String = "Downloads", completion: @escaping (_ result: Result<Void, Error>) -> Void) {
        
        let targetPath = NSHomeDirectory()
        let savePanel = NSSavePanel()
        
        savePanel.directoryURL = URL(fileURLWithPath: targetPath.appending(targetPath))
        savePanel.canCreateDirectories = true
        savePanel.nameFieldStringValue = fileName
        savePanel.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.modalPanelWindow)))
        savePanel.begin { result in
            if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
                
//                try FileManager().copyItem(at: bundleFile, to: result.url)
                completion(.success(()))
            } else {
                completion(.failure(SaveError.saveFailed))
            }
        }
    }
}
