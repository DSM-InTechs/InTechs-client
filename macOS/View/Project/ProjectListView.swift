//
//  AllProjectView.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/08/22.
//

import SwiftUI
import Kingfisher

struct ProjectListView: View {
    @StateObject var viewModel = ProjectViewModel()
    @StateObject var dashboardVM = DashboardViewModel()
    @Namespace private var animation
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Group {
                    switch viewModel.selectedTab {
                    case .dashBoard: DashBoardView()
                            .environmentObject(dashboardVM)
                            .frame(width: geo.size.width / 1.35)
                    case .issues: IssuelistView()
                            .frame(width: geo.size.width / 1.35)
                    case .issueBoards: IssueBoardView()
                            .frame(width: geo.size.width / 1.35)
                    case .settings: SettingView()
                            .environmentObject(viewModel)
                            .frame(width: geo.size.width / 1.35)
                    }
                }.offset(x: geo.size.width / 4)
                
                ZStack {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            KFImage(URL(string: viewModel.projectInfo.image.imageUrl))
                                .resizable()
                                .frame(width: 30, height: 30)
                            Text(viewModel.projectInfo.name)
                            
                            Spacer()
                        }.padding(.horizontal)
                            .padding(.top, 10)
                        
                        Divider()
                            .padding(.vertical)
                        
                        VStack(alignment: .leading) {
                            ProjectList(tab: .dashBoard, selectedTab: $viewModel.selectedTab, animation: animation)
                                .onTapGesture {
                                    withAnimation {
                                        viewModel.selectedTab = .dashBoard
                                    }
                                }
                            
                            ProjectList(tab: .issues, selectedTab: $viewModel.selectedTab, animation: animation)
                                .onTapGesture {
                                    withAnimation {
                                        viewModel.selectedTab = .issues
                                    }
                                }
                            
                            ProjectList(tab: .issueBoards, selectedTab: $viewModel.selectedTab, animation: animation)
                                .onTapGesture {
                                    withAnimation {
                                        viewModel.selectedTab = .issueBoards
                                    }
                                }
                            
                            ProjectList(tab: .settings, selectedTab: $viewModel.selectedTab, animation: animation)
                                .onTapGesture {
                                    withAnimation {
                                        viewModel.selectedTab = .settings
                                    }
                                }
                        }
                        
                        Spacer()
                    }
                    
                    HStack {
                        Color.black.frame(width: 1)
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        Color.black.frame(width: 1)
                    }
                }.background(Color(NSColor.textBackgroundColor)).ignoresSafeArea()
                    .frame(width: geo.size.width / 4)
            }
            .onAppear {
                self.viewModel.apply(.onAppear)
            }
        }.background(Color(NSColor.textBackgroundColor)).ignoresSafeArea()
    }
}

struct AllProjectView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectListView()
            .frame(width: 1000, height: 700)
    }
}

struct ProjectList: View {
    var tab: ProjectTab
    @Binding var selectedTab: ProjectTab
    var animation: Namespace.ID
    
    var body: some View {
        ZStack(alignment: .leading) {
            if tab == selectedTab {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.blue)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 2)
                    .matchedGeometryEffect(id: "color", in: animation)
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.clear)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 2)
            }
            
            if tab == selectedTab {
                HStack {
                    Image(systemName: tab.getImage())
                    Text(tab.rawValue)
                        .fontWeight(.bold)
                }
                .padding(.all, 10)
                .padding(.leading, 20)
            } else {
                HStack {
                    Image(systemName: tab.getImage())
                    Text(tab.rawValue)
                }
                .padding(.all, 10)
                .padding(.leading, 20)
                .foregroundColor(.gray)
            }
        }
        .frame(height: 30)
    }
}
