//
//  CalendarView.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/26.
//

import SwiftUI
import GECalendar

struct CalendarView: View {
    @EnvironmentObject private var homeVM: HomeViewModel
    
    @State var date: Date?
    private let appearance = Appearance(eventType: .line, multipleEvents: [Event(date: Date(), title: "이슈1", color: .green), Event(date: Date(), title: "이슈2", color: .green)], isTodayButton: false, isMultipleEvents: true, headerType: .leading)
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                HStack {
                    GECalendar(selectedDate: $date, appearance: appearance)
                        .padding(date != nil ? .vertical : .all)
                    
                    // Issue...
                    if date != nil {
                        ZStack {
                            CalendarIssuesView(isIssue: $date, title: "이슈1")
                                .environmentObject(homeVM)
                            
                            HStack {
                                Color.black.frame(width: 1)
                                Spacer()
                            }
                        } .frame(width: geo.size.width / 3)
                        .background(Color(NSColor.textBackgroundColor))
                    }
                }
                
                HStack {
                    Color.black.frame(width: 1)
                    Spacer()
                }
            }
        }.background(Color(NSColor.textBackgroundColor)).ignoresSafeArea()
        .padding(.trailing, 70)
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
