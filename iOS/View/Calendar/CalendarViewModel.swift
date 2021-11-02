//
//  CalendarViewModel.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/29.
//

import SwiftUI
import Combine
import GECalendar

class CalendarViewModel: ObservableObject {
    @Published var issues = [CalendarIssue]()
    @Published var profile: Mypage = Mypage(name: "", email: "", image: "")
    @Published var selectedDate: Date?
    @Published var selectedMD: String = ""
    @Published var appearance = Appearance(eventType: .line, multipleEvents: [], isTodayButton: false, isMultipleEvents: true, headerFont: .title2, headerType: .leading)
    
    private var multipleEventsSet = Set<Event>() // 중복 검사
    private var currentDate = Date()
    
    private let calendarRepository: CalendarRepository
    private let issueReporitory: IssueReporitory
    private let mypageRepository: MypageRepository
    
    private let dateFormatter = DateFormatter()
    private let viewDateFormatter = DateFormatter()
    
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
         issueReporitory: IssueReporitory = IssueReporitoryImpl(),
         mypageRepository: MypageRepository = MypageRepositoryImpl()) {
        self.calendarRepository = calendarRepository
        self.issueReporitory = issueReporitory
        self.mypageRepository = mypageRepository
        self.dateFormatter.dateFormat = "yyyy-MM-dd"
        self.viewDateFormatter.dateFormat = "MM dd"
        
        input.onAppear
            .flatMap {
                self.calendarRepository.getCalendar(year: self.currentDate.year, month: self.currentDate.month)
                    .catch { _ -> Empty<[CalendarIssue], Never> in
                        return .init()
                    }
            }
            .sink(receiveValue: { issues in
                self.issues = issues
                issues
                    .filter { $0.endDate != nil }
                    .map {
                        self.multipleEventsSet.insert(Event(date: self.dateFormatter.date(from: $0.endDate!)!, title: $0.title, color: self.stateToColor($0.state)))
                        self.appearance.multipleEvents = Array(self.multipleEventsSet)
                    }
            })
            .store(in: &bag)
        
        input.onAppear
            .flatMap {
                self.mypageRepository.mypage()
                    .catch { _ -> Empty<Mypage, Never> in
                        return .init()
                    }
            }
            .assign(to: \.profile, on: self)
            .store(in: &bag)
        
        self.$selectedDate
            .sink {
                if $0 != nil {
                    self.selectedMD = self.viewDateFormatter.string(from: $0!)
                }
            }
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
