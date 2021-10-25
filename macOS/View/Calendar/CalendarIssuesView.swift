//
//  CalendarIssuesView.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/09/03.
//

import SwiftUI

struct CalendarIssuesView: View {
    @EnvironmentObject private var homeVM: HomeViewModel
    @Binding var isIssue: Date?
    
    @State private var amount = 50.0
    @State private var isEditing = false
    @State private var date = Date()
    
    let title: String
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if isEditing {
                Group {
                    HStack {
                        Text(title)
                        Spacer()
                        if !isEditing {
                            Image(system: .edit)
                                .onTapGesture {
                                    self.isEditing = true
                                }
                        }
                        Image(system: .xmark)
                            .onTapGesture {
                                withAnimation {
                                    self.isIssue = nil
                                }
                            }
                    }
                    
                    VStack(alignment: .leading, spacing: 3) {
                        Text("이슈 설명")
                        TextField("설명", text: .constant(""))
                            .textFieldStyle(PlainTextFieldStyle())
                    }
                    
                    VStack(alignment: .leading, spacing: 3) {
                        Text("이슈 상태")
                        ScrollView(.horizontal) {
                            HStack {
                                HStack {
                                    Circle().frame(width: 10, height: 10)
                                    Text("Open")
                                } .foregroundColor(.blue)
                                
                                HStack {
                                    Circle().frame(width: 10, height: 10)
                                    Text("In Progress")
                                } .foregroundColor(.gray)
                                .opacity(0.5)
                                
                                HStack {
                                    Circle().frame(width: 10, height: 10)
                                    Text("Open")
                                } .foregroundColor(.green)
                                .opacity(0.5)
                            }
                            
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 3) {
                        Text("이슈 마감일")
                        DatePicker("", selection: $date, displayedComponents: .date)
                            .datePickerStyle(CompactDatePickerStyle())
                            .clipped()
                            .labelsHidden()
                    }
                    
                    VStack(alignment: .leading, spacing: 3) {
                        
                        HStack {
                            Text("이슈 진행도")
                            HStack(spacing: 0) {
                                Text(String(amount))
                                Text("%")
                            }
                            .foregroundColor(.blue)
                        }
                        
                        HStack {
                            Button(action: {
                                if amount > 0 {
                                    amount -= 10
                                }
                            }, label: {
                                Image(system: .minus)
                                    .padding()
                            }).buttonStyle(PlainButtonStyle())
                            
                            ProgressView(value: amount, total: 100)
                            
                            Button(action: {
                                if amount < 100 {
                                    amount += 10
                                }
                            }, label: {
                                Image(system: .plus)
                                    .padding()
                            }).buttonStyle(PlainButtonStyle())
                        }
                        
                    }
                    
                    VStack(alignment: .leading, spacing: 3) {
                        Text("이슈 대상자")
                        TextField("이름", text: .constant(""))
                            .textFieldStyle(PlainTextFieldStyle())
                    }
                    
                    Spacer(minLength: 0)
                    
                    HStack {
                        Text("취소")
                            .padding(.all, 10)
                            .padding(.horizontal, 5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(Asset.black), lineWidth: 1)
                            )
                            .onTapGesture {
                                self.isEditing = false
                            }
                        
                        Spacer()
                        
                        Text("확인")
                            .padding(.all, 10)
                            .padding(.horizontal, 5)
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.blue))
                            .onTapGesture {
                                self.isEditing = false
                            }
                        
                    }
                }
            } else {
                Group {
                    HStack {
                        Text(title)
                        Spacer()
                        if !isEditing {
                            Image(system: .edit)
                                .onTapGesture {
                                    self.isEditing = true
                                }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 3) {
                        Text("이슈 설명")
                        Text("비어 있음").foregroundColor(.gray)
                    }
                    
                    VStack(alignment: .leading, spacing: 3) {
                        Text("이슈 상태")
                        HStack {
                            Circle().frame(width: 10, height: 10)
                                .foregroundColor(.blue)
                            Text("Open")
                                .foregroundColor(.blue)
                        }
                        
                    }
                    
                    VStack(alignment: .leading, spacing: 3) {
                        Text("이슈 마감일")
                        Text("2021-10-10")
                            .foregroundColor(.red)
                    }
                    
                    VStack(alignment: .leading, spacing: 3) {
                        
                        HStack {
                            Text("이슈 진행도")
                            Text("50%")
                                .foregroundColor(.blue)
                        }
                        
                        ProgressView(value: amount, total: 100)
                        
                    }
                    
                    VStack(alignment: .leading, spacing: 3) {
                        Text("이슈 대상자")
                        //                        ScrollView {
                        //                            LazyVStack(alignment: .leading) {
                        //                                ForEach(0...10, id: \.self) { _ in
                        //                                    UserBorderRow()
                        //                                }
                        //                            }
                        //                        }
                        Text("비어 있음").foregroundColor(.gray)
                    }
                    
                    Spacer(minLength: 0)
                    
                    HStack {
                        Spacer()
                        Text("삭제")
                            .foregroundColor(Color(Asset.black))
                            .padding(.all, 10)
                            .padding(.horizontal, 10)
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.red))
                            .onTapGesture {
                                withAnimation {
                                    self.homeVM.toast = .issueDelete(execute: {
                                        
                                    })
                                }
                            }
                    }
                }
            }
        }.padding()
        .padding(.leading, 10)
    }
}

struct CalendarIssuesView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarIssuesView(isIssue: .constant(nil), title: "이슈1")
            .frame(width: 300)
            .environmentObject(HomeViewModel())
    }
}
