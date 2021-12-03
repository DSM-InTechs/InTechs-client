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
    
    static func saveFile(fileName: String, targetPath: String = "Downloads", fileUrl: String, completion: @escaping (_ result: Result<Void, Error>) -> Void) {
        
        let targetPath = NSHomeDirectory()
        let savePanel = NSSavePanel()
        
        savePanel.directoryURL = URL(fileURLWithPath: targetPath.appending(targetPath))
        savePanel.canCreateDirectories = true
        savePanel.nameFieldStringValue = fileName
        savePanel.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.modalPanelWindow)))
        savePanel.begin { result in
            if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
                if let url = URL(string: fileUrl) {
                    Downloader.load(url: url, to: savePanel.url!, completion: { result in
                        switch result {
                        case .success(_):
                            completion(.success(()))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    })
                }
            } else {
                completion(.failure(SaveError.saveFailed))
            }
        }
    }
    
    static func saveImage(fileName: String, targetPath: String = "Downloads", image: NSImage, completion: @escaping (_ result: Result<Void, Error>) -> Void) {
        
        let targetPath = NSHomeDirectory()
        let savePanel = NSSavePanel()
        
        savePanel.directoryURL = URL(fileURLWithPath: targetPath.appending(targetPath))
        savePanel.canCreateDirectories = true
        savePanel.nameFieldStringValue = fileName
        savePanel.allowedFileTypes = ["png", "jpg", "jpeg"]
        savePanel.begin { result in
            if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
                if let url = savePanel.url {
                    let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil)!
                    let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
                    let jpegData = bitmapRep.representation(using: NSBitmapImageRep.FileType.png, properties: [:])!
                    do {
                        try jpegData.write(to: url)
                        completion(.success(()))
                    } catch {
                        completion(.failure(error))
                    }
                }
            } else {
                completion(.failure(SaveError.saveFailed))
            }
        }
    }
}
