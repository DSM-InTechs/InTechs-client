//
//  DashBoardView.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/22.
//

import SwiftUI
import GECalendar

struct DashBoardView: View {
    @State private var date: Date?
    private let appearance = Appearance(eventType: .circle, multipleEvents: [Event(date: Date(), title: "이슈1", color: .green), Event(date: Date(), title: "이슈2", color: .green)], isTodayButton: false, isMultipleEvents: true, headerFont: .title2, headerType: .leading)
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading, spacing: geo.size.height / 8) {
                
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Rectangle().foregroundColor(.blue)
                            .frame(width: 40, height: 40)
                        Text("InTechs")
                    }
                    
                    HStack {
                        SystemImage(system: .people)
                            .frame(width: 20, height: 15)
                        Text("3명의 멤버")
                    }
                    
                    HStack(spacing: -10) {
                        Circle().frame(width: 20, height: 20)
                        Circle().frame(width: 20, height: 20)
                        Circle().frame(width: 20, height: 20)
                        Text("+5")
                            .foregroundColor(.black)
                            .font(.caption)
                            .background(Circle().frame(width: 20, height: 20))
                    }
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        SystemImage(system: .issue)
                            .frame(width: 15, height: 20)
                        Text("이슈")
                    }
                    
                    HStack {
                        VStack {
                            IssueRow(text: "For Me", count: 1)
                            IssueRow(text: "Unresolved", count: 1)
                        }
                        
                        VStack {
                            IssueRow(text: "Resolved", count: 1)
                            IssueRow(text: "For me & Unresolved", count: 1)
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        SystemImage(system: .calendar)
                            .frame(width: 17, height: 17)
                        Text("캘린더")
                    }
                    
                    // 주간 캘린더
                    GEWeekView(selectedDate: $date, appearance: appearance)
                    
                    Spacer(minLength: 0)
                }
            }.padding()
            .padding(.trailing, 70)
        }.ignoresSafeArea(.all, edges: .all)
    }
}

struct IssueRow: View {
    var text: String
    var count: Int
    @State private var hover = false
    
    var body: some View {
        HStack {
            Text(text)
            Spacer()
            Text(String(count))
        }.foregroundColor(hover ? .white : .secondary)
        .padding(.all, 10)
        .background(RoundedRectangle(cornerRadius: 5).foregroundColor(.gray.opacity(0.1)))
        .border(Color.gray.opacity(0.3), width: 1)
        .onHover(perform: { hovering in
            self.hover = hovering
        })
    }
}

struct ChecklistRow: View {
    var text: String
    @State private var hover = false
    
    var body: some View {
        HStack {
            Text(text)
            Spacer()
        }.foregroundColor(hover ? .white : .secondary)
        .padding(.all, 10)
        .background(RoundedRectangle(cornerRadius: 5).foregroundColor(.gray.opacity(0.1)))
        .border(Color.gray.opacity(0.3), width: 1)
        .onHover(perform: { hovering in
            self.hover = hovering
        })
    }
}

struct DashBoardView_Previews: PreviewProvider {
    static var previews: some View {
        DashBoardView()
            .frame(width: 1000, height: 700)
    }
}
