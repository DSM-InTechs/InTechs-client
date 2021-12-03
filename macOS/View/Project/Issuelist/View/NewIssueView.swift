//
//  NewIssueView.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/09/04.
//

import SwiftUI
import Kingfisher

struct NewIssueView: View {
    let execute: () -> Void
    @EnvironmentObject var homeVM: HomeViewModel
    @ObservedObject var viewModel = NewIssueViewModel()
    
    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 25) {
                VStack(spacing: 20) {
                    TextField("제목", text: $viewModel.title)
                        .font(.title)
                        .textFieldStyle(PlainTextFieldStyle())
                    
                    HStack {
                        Text("이슈 설명")
                            .onTapGesture {
                                self.viewModel.isBody.toggle()
                            }
                        Spacer()
                        if  self.viewModel.isBody {
                            Image(system: .xmark)
                                .onTapGesture {
                                    self.viewModel.isBody = false
                                }
                        } else {
                            Image(system: .plus)
                                .onTapGesture {
                                    self.viewModel.isBody = true
                                }
                        }
                    }
                    
                    if viewModel.isBody {
                        TextField("설명", text: $viewModel.body)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(.all, 5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color(Asset.black), lineWidth: 1)
                            )
                    }
                    
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
                                self.viewModel.apply(.create)
                                withAnimation {
                                    self.homeVM.toast = nil
                                }
                                execute()
                            }
                    }
                }
                
                // Issue Detail View
                VStack(spacing: 30) {
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
                        }.padding(.bottom, 5)
                        
                        VStack(alignment: .leading, spacing: 3) {
                            HStack {
                                Text("이슈 상태")
                                
                                Spacer()
                            }
                            
                            ScrollView(.horizontal) {
                                HStack {
                                    HStack {
                                        Circle().frame(width: 10, height: 10)
                                        Text("Ready")
                                    } .foregroundColor(.blue)
                                        .opacity(  self.viewModel.state == .ready ? 1.0 : 0.5)
                                        .onTapGesture {
                                            self.viewModel.changeIssueState(.ready)
                                        }
                                    
                                    HStack {
                                        Circle().frame(width: 10, height: 10)
                                        Text("In Progress")
                                    } .foregroundColor(.gray)
                                        .opacity(  self.viewModel.state == .progress ? 1.0 : 0.5)
                                        .onTapGesture {
                                            self.viewModel.changeIssueState(.progress)
                                        }
                                    
                                    HStack {
                                        Circle().frame(width: 10, height: 10)
                                        Text("Done")
                                    } .foregroundColor(.green)
                                        .opacity(  self.viewModel.state == .done ? 1.0 : 0.5)
                                        .onTapGesture {
                                            self.viewModel.changeIssueState(.done)
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
                                if  self.viewModel.isProgress {
                                    
                                    HStack(spacing: 0) {
                                        Text(String(viewModel.progress))
                                        Text("%")
                                    }
                                    .foregroundColor(.blue)
                                }
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
                        
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("이슈 대상자")
                                Spacer()
                                if  self.viewModel.isUser {
                                    Image(system: .xmark)
                                        .onTapGesture {
                                            self.viewModel.isUser = false
                                        }
                                } else {
                                    Image(system: .plus)
                                        .onTapGesture {
                                            self.viewModel.isUser = true
                                        }
                                }
                            }
                            
                            if self.viewModel.isUser {
                                if viewModel.users.isEmpty == false {
                                    LazyVStack(alignment: .leading) {
                                        ForEach(0...viewModel.users.count - 1, id: \.self) { index in
                                            HStack {
                                                KFImage(URL(string: viewModel.users[index].imageURL))
                                                    .resizable()
                                                    .clipShape(Circle())
                                                    .frame(width: 20, height: 20)
                                                
                                                Text(viewModel.users[index].name)
                                                Spacer()
                                                if viewModel.users[index].isSelected {
                                                    Image(system: .checkmark)
                                                }
                                            }
                                            .onTapGesture {
                                                viewModel.users[index].isSelected.toggle()
                                            }
                                        }
                                    }.padding(.leading, 10)
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("태그")
                                Spacer()
                                if  self.viewModel.isTag {
                                    Image(system: .xmark)
                                        .onTapGesture {
                                            self.viewModel.isTag = false
                                        }
                                } else {
                                    Image(system: .plus)
                                        .onTapGesture {
                                            self.viewModel.isTag = true
                                        }
                                }
                            }
                            
                            if self.viewModel.isTag {
                                HStack(spacing: 20) {
                                    TextField("새 태그 추가", text: $viewModel.newTag)
                                    
                                    Text("추가")
                                        .foregroundColor(Color(Asset.black))
                                        .padding(.all, 5)
                                        .padding(.horizontal, 10)
                                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.blue))
                                        .onTapGesture {
                                            viewModel.tags.append( SelectIssueTag(tag: IssueTag(tag: viewModel.newTag)))
                                            viewModel.newTag = ""
                                        }
                                }
                                
                                if viewModel.tags.isEmpty == false {
                                    LazyVStack(alignment: .leading) {
                                        ForEach(0...viewModel.tags.count - 1, id: \.self) { index in
                                            HStack {
                                                Text("# \(viewModel.tags[index].tag)")
                                                    .padding(.all, 10)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 10).foregroundColor(.clear).border(Color.gray.opacity(0.5))
                                                    )
                                                Spacer()
                                                if viewModel.tags[index].isSelected {
                                                    Image(system: .checkmark)
                                                }
                                            }.onTapGesture {
                                                viewModel.tags[index].isSelected.toggle()
                                            }
                                        }
                                    }.padding(.leading, 10)
                                }
                            }
                        }
                        
                        Spacer(minLength: 0)
                    }
                }
                .frame(width: geo.size.width / 3)
            }.padding()
                .padding(.all, 5)
                .onAppear {
                    viewModel.apply(.onAppear)
                }
        }
    }
}

struct NewIssueView_Previews: PreviewProvider {
    static var previews: some View {
        NewIssueView(execute: {
            
        })
    }
}
