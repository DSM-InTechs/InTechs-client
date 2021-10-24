//
//  NewIssueView.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/09/04.
//

import SwiftUI

struct NewIssueView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    @ObservedObject var viewModel = NewIssueViewModel()
    
    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 25) {
                VStack(spacing: 20) {
                    TextField("제목", text: $viewModel.title)
                        .font(.title)
                        .textFieldStyle(PlainTextFieldStyle())
                    
                    TextField("Descriptiong (선택)", text: .constant(""))
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.all, 5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color(Asset.black), lineWidth: 1)
                        )
                    
                    Spacer()
                    
                    HStack {
                        Text("취소")
                            .padding(.all, 5)
                            .padding(.horizontal, 10)
                            .font(.title3)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(Asset.black), lineWidth: 1)
                            )
                            .onTapGesture {
                                withAnimation {
                                    self.homeVM.toast = nil
                                }
                            }
                        
                        Spacer()
                        
                        Text("생성")
                            .padding(.all, 5)
                            .padding(.horizontal, 10)
                            .font(.title3)
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.blue))
                            .onTapGesture {
                                withAnimation {
                                    self.homeVM.toast = nil
                                }
                            }
                    }
                }
                
                // Issue Detail View
                VStack(spacing: 20) {
                    Group {
                        HStack {
                            Spacer()
                            
                            Image(system: .xmark)
                                .foregroundColor(.gray)
                                .font(.title2)
                                .onTapGesture {
                                    withAnimation {
                                        self.homeVM.toast = nil
                                    }
                                }
                        }
                        
                        VStack(alignment: .leading, spacing: 3) {
                            Text("이슈 상태")
                            ScrollView(.horizontal) {
                                HStack {
                                    HStack {
                                        Circle().frame(width: 10, height: 10)
                                        Text("Ready")
                                    } .foregroundColor(.blue)
                                        .opacity(  self.viewModel.state == .ready ? 1.0 : 0.5)
                                        .onTapGesture {
                                            self.viewModel.state = .ready
                                        }
                                    
                                    HStack {
                                        Circle().frame(width: 10, height: 10)
                                        Text("In Progress")
                                    } .foregroundColor(.gray)
                                        .opacity(  self.viewModel.state == .progress ? 1.0 : 0.5)
                                    .onTapGesture {
                                        self.viewModel.state = .progress
                                    }
                                    
                                    HStack {
                                        Circle().frame(width: 10, height: 10)
                                        Text("Done")
                                    } .foregroundColor(.green)
                                        .opacity(  self.viewModel.state == .done ? 1.0 : 0.5)
                                    .onTapGesture {
                                        self.viewModel.state = .done
                                    }
                                }
                                
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 3) {
                            HStack {
                                Text("이슈 마감일")
                                Spacer()
                                if  self.viewModel.isDate {
                                    Image(system: .xmark)
                                        .onTapGesture {
                                            self.viewModel.isDate = false
                                        }
                                } else {
                                    Image(system: .plus)
                                        .onTapGesture {
                                            self.viewModel.isDate = true
                                        }
                                }
                                
                            }
                            
                            if self.viewModel.isDate {
                                DatePicker("", selection: $viewModel.date, displayedComponents: .date)
                                    .datePickerStyle(CompactDatePickerStyle())
                                    .clipped()
                                    .labelsHidden()
                            }
                            
                        }
                        
                        VStack(alignment: .leading, spacing: 3) {
                            
                            HStack {
                                Text("이슈 진행도")
                                HStack(spacing: 0) {
                                    Text(String(viewModel.progress))
                                    Text("%")
                                }
                                .foregroundColor(.blue)
                                Spacer()
                                if  self.viewModel.isProgress {
                                    Image(system: .xmark)
                                        .onTapGesture {
                                            self.viewModel.isProgress = false
                                        }
                                } else {
                                    Image(system: .plus)
                                        .onTapGesture {
                                            self.viewModel.isProgress = true
                                        }
                                }
                                
                            }
                            
                            if self.viewModel.isProgress {
                                HStack {
                                    Button(action: {
                                        if viewModel.progress > 0 {
                                            viewModel.progress -= 10
                                        }
                                    }, label: {
                                        Image(system: .minus)
                                            .padding()
                                    }).buttonStyle(PlainButtonStyle())
                                    
                                    ProgressView(value: viewModel.progress, total: 100)
                                    
                                    Button(action: {
                                        if viewModel.progress < 100 {
                                            viewModel.progress += 10
                                        }
                                    }, label: {
                                        Image(system: .plus)
                                            .padding()
                                    }).buttonStyle(PlainButtonStyle())
                                }
                            }
                            
                        }
                        
                        VStack(alignment: .leading, spacing: 3) {
                            Text("이슈 대상자")
                            TextField("검색", text: $viewModel.searchUser)
                                .textFieldStyle(PlainTextFieldStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 3) {
                            Text("태그")
                            TextField("검색", text: $viewModel.searchTag)
                                .textFieldStyle(PlainTextFieldStyle())
                            
                            if self.viewModel.searchTag != "" {
                                LazyVStack {
                                    ForEach(viewModel.searchUser, id: \.self) { text in
                                        Text(text)
                                    }
                                }
                            }
                        }
                        
                        Spacer(minLength: 0)
                        
                    }
                }
                .frame(width: geo.size.width / 3)
            }.padding()
            .padding(.all, 5)
        }
    }
}

struct NewIssueView_Previews: PreviewProvider {
    static var previews: some View {
        NewIssueView()
    }
}
