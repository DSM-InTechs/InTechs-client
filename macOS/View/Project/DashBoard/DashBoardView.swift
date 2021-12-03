//
//  DashBoardView.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/22.
//

import SwiftUI
import GECalendar
import Kingfisher

struct DashBoardView: View {
    @EnvironmentObject var projectVM: ProjectViewModel
    @EnvironmentObject var viewModel: DashboardViewModel
    @State private var date: Date?
    @State private var appearance = Appearance(eventType: .circle,
                                               multipleEvents: [],
                                               isTodayButton: false,
                                               isMultipleEvents: true,
                                               headerFont: .title2, headerType: .leading)
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading, spacing: geo.size.height / 8) {
                
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        KFImage(URL(string: viewModel.projectInfo.image.imageUrl))
                            .resizable()
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .frame(width: 40, height: 40)
                        Text(viewModel.projectInfo.name)
                    }
                    
                    HStack {
                        SystemImage(system: .people)
                            .frame(width: 20, height: 15)
                        Text("\(viewModel.dashboard.userCount)명의 멤버")
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
                            IssueRow(text: "For Me", count: viewModel.dashboard.issuesCount.forMe)
                                .onTapGesture {
                                    self.projectVM.selectedTab = .issues
                                }
                            IssueRow(text: "Unresolved", count: viewModel.dashboard.issuesCount.unresolved)
                                .onTapGesture {
                                    self.projectVM.selectedTab = .issues
                                }
                        }
                        
                        VStack {
                            IssueRow(text: "Resolved", count: viewModel.dashboard.issuesCount.resolved)
                                .onTapGesture {
                                    self.projectVM.selectedTab = .issues
                                }
                            IssueRow(text: "For me & Unresolved", count: viewModel.dashboard.issuesCount.forMeAndUnresolved)
                                .onTapGesture {
                                    self.projectVM.selectedTab = .issues
                                }
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
                    GEWeekView(selectedDate: $date, appearance: $appearance)
                    
                    Spacer(minLength: 0)
                }
            }.padding()
                .padding(.trailing, 70)
                .onAppear {
                    self.viewModel.apply(.onAppear)
                }
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
