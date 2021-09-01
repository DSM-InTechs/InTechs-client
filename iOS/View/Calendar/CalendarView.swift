//
//  CalendarView.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/22.
//

import SwiftUI
import GECalendar

struct CalendarView: View {
    @ObservedObject var calendarVM = CalendarViewModel()
    @State var uiTabarController: UITabBarController?
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                ZStack {
                    GECalendar(selectedDate: $calendarVM.date, appearance:  Appearance(multipleEvents: calendarVM.events, isMultipleEvents: true, headerFont: .title2))
                    
                    VStack {
                        Spacer()
                        VStack(alignment: .leading) {
                            Text(calendarVM.dateFormatter.string(from: calendarVM.date!))
                                .foregroundColor(.gray)
                                .fontWeight(.bold)
                                .font(.title2)
                                .padding(.horizontal, 20)
                            
                            LazyVStack(spacing: 20) {
                                ForEach(0...1, id: \.self) { _ in
                                    NavigationLink(destination: IssueDetailView()) {
                                        CalendarIssueRow()
                                            .padding(.horizontal)
                                    }
                                }
                            }.padding(.horizontal)
                            Spacer()
                        }
                        .frame(height: geo.size.height / 2)
                    }
                    
                }
            }.padding(.vertical)
            .navigationBarTitle("마이페이지", displayMode: .inline)
            .navigationBarItems(trailing:
                                    NavigationLink(destination: MypageView()) {
                                        Circle().frame(width: 25, height: 25)
                                    }
            )
            .introspectTabBarController { (UITabBarController) in
                UITabBarController.tabBar.isHidden = false
                uiTabarController = UITabBarController
            }.onAppear() {
                uiTabarController?.tabBar.isHidden = false
            }
        }
    }
}

struct CalendarIssueRow: View {
    let isIssue: Bool = true
    let title: String = "이슈1"
    
    var body: some View {
        HStack {
            Circle().foregroundColor(isIssue ? .green : .blue)
                .frame(width: 10, height: 10)
            Text(title)
                .foregroundColor(Color(Asset.black))
            Spacer()
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(UIColor.secondarySystemBackground)))
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
