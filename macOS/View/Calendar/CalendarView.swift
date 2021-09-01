//
//  CalendarView.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/26.
//

import SwiftUI
import GECalendar

struct CalendarView: View {
    @State var date: Date?
    var lastDate: Date?
    private let appearance = Appearance(isTodayButton: false, headerType: .leading)
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                HStack {
                    GECalendar(selectedDate: $date, appearance: appearance)
                        .padding(.vertical)
                    
                    // Issue...
                    if date != nil && date != lastDate {
                        ZStack {
                            IssueDetailView(title: "이슈1")
                            
                            HStack {
                                Color.black.frame(width: 1)
                                Spacer()
                            }
                        } .frame(width: geo.size.width / 3)
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
