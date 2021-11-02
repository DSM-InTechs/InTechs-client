//
//  CalendarView.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/22.
//

import SwiftUI
import GECalendar
import Kingfisher

struct CalendarView: View {
    @ObservedObject var viewModel = CalendarViewModel()
    @State var uiTabarController: UITabBarController?
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                ZStack {
                    GECalendar(selectedDate: $viewModel.selectedDate,
                               appearance: $viewModel.appearance,
                               onChanged: { self.viewModel.onChanged($0) })
                    
                    VStack {
                        Spacer()
                        VStack(alignment: .leading) {
                            Text(viewModel.selectedMD)
                                .foregroundColor(.gray)
                                .fontWeight(.bold)
                                .font(.title2)
                                .padding(.horizontal, 20)
                            
                            LazyVStack(spacing: 20) {
                                ForEach(viewModel.issues, id: \.self) { issue in
                                    NavigationLink(destination: IssueDetailView(id: issue.id)) {
                                        CalendarIssueRow(state: issue.state, title: issue.title)
                                            .padding(.horizontal)
                                    }
                                }
                            }.padding(.horizontal)
                            Spacer()
                        }
                        .frame(height: geo.size.height / 2.3)
                    }
                    
                }
            }.padding(.vertical)
                .navigationBarTitle("마이페이지", displayMode: .inline)
                .navigationBarItems(trailing:
                                        NavigationLink(destination: MypageView()) {
                    KFImage(URL(string: viewModel.profile.image))
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 25, height: 25)
                }
                )
                .introspectTabBarController { (UITabBarController) in
                    UITabBarController.tabBar.isHidden = false
                    uiTabarController = UITabBarController
                }.onAppear {
                    uiTabarController?.tabBar.isHidden = false
                }
        }.onAppear {
            self.viewModel.apply(.onAppear)
        }
    }
}

struct CalendarIssueRow: View {
    let state: String?
    let title: String
    
    var body: some View {
        HStack {
            switch state {
            case IssueState.ready.rawValue:
                Circle()
                    .foregroundColor(.green)
                    .frame(width: 10, height: 10)
            case IssueState.progress.rawValue:
                Circle()
                    .foregroundColor(.gray)
                    .frame(width: 10, height: 10)
            case IssueState.done.rawValue:
                Circle()
                    .foregroundColor(.blue)
                    .frame(width: 10, height: 10)
            default:
                Text("").hidden()
            }
            
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
