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
    
    @State private var assigneePop: Bool = false
    @State private var statePop: Bool = false
    @State private var tagPop: Bool = false
    
    var body: some View {
        GeometryReader { _ in
            ZStack {
                VStack {
                    HStack(spacing: 20) {
                        HStack(spacing: 3) {
                            Text("상태")
                            Image(system: .downArrow)
                                .font(.caption)
                        }.onTapGesture {
                            self.statePop.toggle()
                        }.popover(isPresented: self.$statePop) {
                            IssueFilterStateView(state: $viewModel.state,
                                                 execute: { viewModel.apply(.reloadlist) })
                                .padding()
                        }
                        
                        HStack(spacing: 3) {
                            Text("대상자")
                            Image(system: .downArrow)
                                .font(.caption)
                        }.onTapGesture {
                            self.assigneePop.toggle()
                        }.popover(isPresented: self.$assigneePop) {
                            IssueFilterUserView(users: $viewModel.users,
                                                execute: { viewModel.apply(.reloadlist) })
                                .frame(width: 200)
                        }
                        
                        HStack(spacing: 3) {
                            Text("태그")
                            Image(system: .downArrow)
                                .font(.caption)
                        }.onTapGesture {
                            self.tagPop.toggle()
                        }.popover(isPresented: self.$tagPop) {
                            IssueFilterTagView(tags: $viewModel.tags,
                                               execute: { viewModel.apply(.reloadlist) })
                                .frame(width: 200)
                        }
                        
                        HStack(spacing: 3) {
                            Image(system: .search)
                            TextField("검색", text: .constant(""))
                                .textFieldStyle(PlainTextFieldStyle())
                        }
                        
                        Spacer()
                    }
                    
                    GECalendar(selectedDate: $viewModel.selectedDate,
                               appearance: $viewModel.appearance,
                               onChanged: { viewModel.onChanged($0) })
                        .padding(viewModel.selectedDate != nil ? .vertical : .all)
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
