//
//  NetworkError.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/10/04.
//

import Foundation
import Moya

public enum NetworkError: Int, Error {
    case unknown = 0
    case noInternet = 1
    case ok = 200
    case error = 400
    case unauthorized = 401
    case notMatch = 403
    case notFound = 404
    case conflict = 409
    case serverError = 500
    case badGateway = 502
    
    public init(_ error: MoyaError) {
        print("INTECHS ERROR: \(error), \(error.response)")
        if error.response == nil {
            self = .noInternet
        } else {
            let code = error.response!.statusCode
            let networkError = NetworkError(rawValue: code)
            self = networkError ?? .unknown
        }
    }
    
    public init(_ error: Error) {
        if let moyaError = error as? MoyaError {
            self = NetworkError(moyaError)
        } else {
            self = NetworkError.unknown
        }
    }
    
    public var message: String {
        switch self {
        case .noInternet: return "인터넷에 연결되어 있지 않습니다."
        case .error: return "400 에러"
        case .unauthorized: return "로그인을 다시 해주십시오."
        case .notMatch: return "403"
        case .notFound: return "찾을 수 없습니다."
        case .conflict: return "409"
        case .serverError: return "서버 오류가 존재합니다."
        default: return ""
        }
    }
}
