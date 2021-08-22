//
//  AllProjectView.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/08/22.
//

import SwiftUI

struct ProjectListView: View {
    @ObservedObject var projectVM = ProjectViewModel()
    @Namespace private var animation
    
    var body: some View {
        GeometryReader { geo in
            HStack {
                ZStack {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(spacing: 15) {
                            Text("Project")
                                .font(.title)
                            
                            Spacer()
                        }.padding()
                        
                        HStack {
                            Rectangle().foregroundColor(.blue)
                                .frame(width: 30, height: 30)
                            Text("InTechs")
                            
                            Spacer()
                        }.padding()
                        
                        VStack(alignment: .leading) {
                            ProjectList(tab: .DashBoard, selectedTab: $projectVM.selectedTab, animation: animation)
                                .onTapGesture {
                                    withAnimation {
                                        projectVM.selectedTab = .DashBoard
                                    }
                                }
                            
                            ProjectList(tab: .Issues, selectedTab: $projectVM.selectedTab, animation: animation)
                                .onTapGesture {
                                    withAnimation {
                                        projectVM.selectedTab = .Issues
                                    }
                                }
                            
                            ProjectList(tab: .IssueBoards, selectedTab: $projectVM.selectedTab, animation: animation)
                                .onTapGesture {
                                    withAnimation {
                                        projectVM.selectedTab = .IssueBoards
                                    }
                                }
                            
                            ProjectList(tab: .Settings, selectedTab: $projectVM.selectedTab, animation: animation)
                                .onTapGesture {
                                    withAnimation {
                                        projectVM.selectedTab = .Settings
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
                }.ignoresSafeArea(.all, edges: .all)
                .frame(width: geo.size.width / 4)
                
                switch projectVM.selectedTab {
                case .DashBoard: DashBoardView()
                    .frame(width: geo.size.width / 1.35)
                case .Issues: IssuelistView()
                case .IssueBoards: IssueBoardView()
                case .Settings: Text("")
                }
            }
        }
    }
}

struct AllProjectView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectListView()
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
