//
//  NewIssueView.swift
//  InTechs (macOS)
//
//  Created by GoEun Jeong on 2021/09/04.
//

import SwiftUI

struct NewIssueView: View {
    @State private var date = Date()
    @State private var amount = 0.0
    @EnvironmentObject var homeVM: HomeViewModel
    
    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 25) {
                VStack(spacing: 20) {
                    TextField("제목", text: .constant(""))
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
                VStack {
                    Group {
                        HStack {
                            Text("title")
                            
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
