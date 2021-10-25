//
//  CalendarViewModel.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/10/07.
//

import SwiftUI
import Combine
import GECalendar

class CalendarViewModel: ObservableObject {
    @Published var members: [ProjectMember] = [ProjectMember]()
    @Published var date: Date?
    @Published var appearance = Appearance(eventType: .line, multipleEvents: [Event(date: Date(), title: "이슈1", color: .green), Event(date: Date(), title: "이슈2", color: .green)], isTodayButton: false, isMultipleEvents: true, headerType: .leading)
    
    private let calendarRepository: CalendarRepository
    private let dateFormatter = DateFormatter()
    
    private var bag = Set<AnyCancellable>()
    
    public enum ViewModelEvent {
        case onAppear
    }
    
    public struct Input {
        let onAppear = PassthroughSubject<Void, Never>()
    }
    
    public let input = Input()
    
    public func apply(_ input: ViewModelEvent) {
        switch input {
        case .onAppear:
            self.input.onAppear.send(())
        }
    }
    
    init(calendarRepository: CalendarRepository = CalendarRepositoryImpl()) {
        self.calendarRepository = calendarRepository
        self.dateFormatter.dateFormat = "yyyy-MM-dd"
        
//        input.getMembers
//            .flatMap {
//                self.projectRepository.getProjectMembers()
//                    .catch { _ -> Empty<[ProjectMember], Never> in
//                        return .init()
//                    }
//            }
//            .assign(to: \.members, on: self)
//            .store(in: &bag)
    }
    
    private func getErrorMessage(error: NetworkError) -> String {
        switch error {
        case .notFound:
            return "유저를 찾을 수 없습니다."
        case .unauthorized:
            return "토큰이 만료되었습니다."
        default:
            return error.message
        }
    }
}
