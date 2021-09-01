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
    @Published var date: Date? = Date()
    private var cancellable = Set<AnyCancellable>()
    let dateFormatter = DateFormatter()
    
    init() {
        dateFormatter.dateFormat = "MM dd"
        
        self.$date
            .sink { _ in
                // do something here with newQuery
            }
            .store(in: &cancellable)
    }
    
    func getCalendar() {
        
    }
    
}
