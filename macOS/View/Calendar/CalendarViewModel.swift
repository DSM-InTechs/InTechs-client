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
    //    @Published var issues: [ProjectMember] = [ProjectMember]()
    @Published var selectedDate: Date?
    @Published var appearance = Appearance(eventType: .line, multipleEvents: [], isTodayButton: false, isMultipleEvents: true, headerType: .leading)
    
    @Published var users = [SelectIssueUser]()
    @Published var tags = [SelectIssueTag]()
    @Published var state: IssueState?
    
    private var multipleEventsSet = Set<Event>() // 중복 검사
    private var currentDate = Date()
    
    private let calendarRepository: CalendarRepository
    private let issueReporitory: IssueReporitory
    private let dateFormatter = DateFormatter()
    
    private var bag = Set<AnyCancellable>()
    
    public enum ViewModelEvent {
        case onAppear
        case reloadlist
    }
    
    public struct Input {
        let onAppear = PassthroughSubject<Void, Never>()
        let getFilteringList = PassthroughSubject<Void, Never>()
        let reloadlist = PassthroughSubject<Void, Never>()
    }
    
    public let input = Input()
    
    public func apply(_ input: ViewModelEvent) {
        switch input {
        case .onAppear:
            self.input.onAppear.send(())
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5, execute: {
                self.input.getFilteringList.send(())
            })
        case .reloadlist:
            self.input.reloadlist.send(())
        }
    }
    
    init(calendarRepository: CalendarRepository = CalendarRepositoryImpl(),
         issueReporitory: IssueReporitory = IssueReporitoryImpl()) {
        self.calendarRepository = calendarRepository
        self.issueReporitory = issueReporitory
        self.dateFormatter.dateFormat = "yyyy-MM-dd"
        
        input.onAppear
            .flatMap {
                self.calendarRepository.getCalendar(year: self.currentDate.year, month: self.currentDate.month)
                    .catch { _ -> Empty<[CalendarIssue], Never> in
                        return .init()
                    }
            }
            .sink(receiveValue: { issues in
                issues
                    .filter { $0.endDate != nil }
                    .map {
                        self.multipleEventsSet.insert(Event(date: self.dateFormatter.date(from: $0.endDate!)!, title: $0.title, color: self.stateToColor($0.state)))
                        self.appearance.multipleEvents = Array(self.multipleEventsSet)
                    }
                print(self.appearance.multipleEvents)
            })
            .store(in: &bag)
        
        input.getFilteringList
            .flatMap {
                self.issueReporitory.getUserlist()
                    .catch { _ -> Empty<[IssueUser], Never> in
                        return .init()
                    }
            }
            .map { $0.map { return SelectIssueUser(user: $0) } }
            .assign(to: \.users, on: self)
            .store(in: &bag)
        
        input.getFilteringList
            .flatMap {
                self.issueReporitory.getTaglist()
                    .catch { _ -> Empty<[IssueTag], Never> in
                        return .init()
                    }
            }
            .map { $0.map { return SelectIssueTag(tag: $0) } }
            .assign(to: \.tags, on: self)
            .store(in: &bag)
        
        input.reloadlist
            .collect(.byTime(DispatchQueue.main, .seconds(1)))
            .flatMap { _ in
                self.calendarRepository.getCalendar(year: self.currentDate.year,
                                                    month: self.currentDate.month,
                                                    tags: self.tags.filter { $0.isSelected == true }.map { $0.tag },
                                                    users: self.users.filter { $0.isSelected == true }.map { $0.email },
                                                    states: (self.state != nil) ? [self.state!.rawValue] : nil)
                    .catch { _ -> Empty<[CalendarIssue], Never> in
                        return .init()
                    }
            }
            .sink(receiveValue: { issues in
                issues
                    .filter { $0.endDate != nil }
                    .map {
                        self.multipleEventsSet.insert(Event(date: self.dateFormatter.date(from: $0.endDate!)!, title: $0.title, color: self.stateToColor($0.state)))
                        self.appearance.multipleEvents = Array(self.multipleEventsSet)
                    }
                print(self.appearance.multipleEvents)
            })
            .store(in: &bag)
    }
    
    public func onChanged(_ date: Date) {
        print(date)
        self.currentDate = date
        self.apply(.onAppear)
    }
    
    private func stateToColor(_ state: String?) -> Color {
        switch state {
        case IssueState.ready.rawValue:
            return Color.green
        case IssueState.progress.rawValue:
            return Color.gray
        case IssueState.done.rawValue:
            return Color.blue
        default:
            return Color.clear
        }
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
