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
    @Published var events: [Event] = [Event]()
    @Published var date: Date? = nil
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        self.$date
            .sink { date in
                // do something here with newQuery
            }
            .store(in: &cancellable)
    }
    
    func getCalendar() {
        
    }
    
}
