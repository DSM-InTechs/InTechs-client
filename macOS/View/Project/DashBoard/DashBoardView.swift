//
//  DashBoardView.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/22.
//

import SwiftUI

struct DashBoardView: View {
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading, spacing: geo.size.height / 8) {
                
                VStack(spacing: 20) {
                    HStack {
                        Rectangle().foregroundColor(.blue)
                            .frame(width: 40, height: 40)
                        Text("InTechs")
                    }
                    
                    HStack {
                        SystemImage(system: .people)
                            .frame(width: 20, height: 15)
                        Text("3 Members")
                    }
                    
                    HStack {
                        // 사람 프사들
                    }
                }
                
                VStack(alignment: .leading) {
                    HStack {
                        SystemImage(system: .issue)
                            .frame(width: 15, height: 20)
                        Text("Issues")
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
                
                VStack(alignment: .leading) {
                    HStack {
                        SystemImage(system: .calendar)
                            .frame(width: 17, height: 17)
                        Text("Calendar")
                    }
                    
                    // 주간 캘린더
//                    VStack(spacing: 0) {
//                        NoChecklistRow()
//                    }
                }
                
                Spacer()
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

struct NoChecklistRow: View {
    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            Text("No checklists in this project.")
            Spacer()
        } .padding(.all, 15)
        .background(RoundedRectangle(cornerRadius: 5).foregroundColor(.clear))
        .border(Color.gray.opacity(0.3), width: 1)
        
    }
}

struct DashBoardView_Previews: PreviewProvider {
    static var previews: some View {
        DashBoardView()
    }
}
