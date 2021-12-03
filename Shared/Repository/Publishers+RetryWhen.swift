//
//  Moya+Retry.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/11/25.
//

import Combine

extension Publishers {
    struct RetryIf<P: Publisher>: Publisher {
        typealias Output = P.Output
        typealias Failure = P.Failure
        
        let publisher: P
        let times: Int
        let condition: (P.Failure) -> Bool
        
        func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
            guard times > 0 else { return publisher.receive(subscriber: subscriber) }
            
            publisher.catch { (error: P.Failure) -> AnyPublisher<Output, Failure> in
                if condition(error)  {
                    return RetryIf(publisher: publisher, times: times - 1, condition: condition).eraseToAnyPublisher()
                } else {
                    return Fail(error: error).eraseToAnyPublisher()
                }
            }.receive(subscriber: subscriber)
        }
    }
}

extension Publisher {
    func retry(times: Int = 1, when condition: @escaping (Failure) -> Bool) -> Publishers.RetryIf<Self> {
        Publishers.RetryIf(publisher: self, times: times, condition: condition)
    }
    
    func retryWithAuthIfNeeded() -> Publishers.RetryIf<Self> {
        return self.retry { error in
            let networkError = NetworkError(error)
            if networkError == .unauthorized || networkError == .notMatch || networkError == .notFound {
                RefreshRepositoryImpl().refresh()
                return true
            }
            return false
        }
    }
}
