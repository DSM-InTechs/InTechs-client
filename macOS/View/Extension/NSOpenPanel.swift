//
//  NSOpenPanel.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/30.
//

import SwiftUI

extension NSOpenPanel {
    // Image 가져오기 실패 시 사용
    enum ImageError: Error {
        case selectionFailed
    }
    
    static func openImage(completion: @escaping (_ result: Result<NSImage, Error>) -> Void) {
        let panel = NSOpenPanel()
        // 다중 선택가능?
        panel.allowsMultipleSelection = false
        // 파일 선택가능?
        panel.canChooseFiles = true
        // 폴더 선택가능?
        panel.canChooseDirectories = false
        // 가져올 수 있는 파일형식
        panel.allowedFileTypes = ["jpg", "jpeg", "png"]
        // 열기 눌렀을 때
        panel.begin { result in
            guard
                result == .OK,
                let url = panel.urls.first,
                let image = NSImage(contentsOf: url)
            else {
                completion(.failure(ImageError.selectionFailed))
                return
            }
            completion(.success(image))
        }
    }
    
    static func openFile(completion: @escaping (_ result: Result<(String, Data), Error>) -> Void) {
        let panel = NSOpenPanel()
        // 다중 선택가능?
        panel.allowsMultipleSelection = false
        // 파일 선택가능?
        panel.canChooseFiles = true
        // 폴더 선택가능?
        panel.canChooseDirectories = false
        // 열기 눌렀을 때
        panel.begin { result in
            guard
                result == .OK,
                let url = panel.urls.first
            else {
                completion(.failure(ImageError.selectionFailed))
                return
            }
            do {
                let data = try Data(contentsOf: url)
                completion(.success((url.path.lastPathComponent, data)))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
