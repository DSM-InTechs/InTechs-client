//
//  Downloader.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/11/25.
//

import Foundation

class Downloader {
    
    // 저장 실패 시 사용
    enum WriteError: Error {
        case writeFailed
    }
    
    class func load(url: URL, to localUrl: URL, completion: @escaping (_ result: Result<Void, Error>) -> Void) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let request = try! URLRequest(url: url, method: .get)
        
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                do {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: localUrl)
                    completion(.success(()))
                } catch (let writeError) {
                    completion(.failure(writeError))
                }
                
            } else {
                completion(.failure(WriteError.writeFailed))
            }
        }
        task.resume()
    }
}
