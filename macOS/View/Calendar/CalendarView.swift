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
    @ObservedObject var viewModel = CalendarViewModel()
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                HStack {
                    GECalendar(selectedDate: $viewModel.date, appearance: viewModel.appearance)
                        .padding(viewModel.date != nil ? .vertical : .all)
                    
                    // Issue...
                    if viewModel.date != nil {
                        ZStack {
//                            IssueDetailView(currentIssue: <#T##Binding<Issue?>#>, title: <#T##String#>)
                            CalendarIssuesView(isIssue: $viewModel.date, title: "이슈1")
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
        .onAppear {
            self.viewModel.apply(.onAppear)
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
