//
//  CalendarView.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/26.
//

import SwiftUI
import GECalendar

struct CalendarView: View {
    @State var date: Date? = nil
    var lastDate: Date? = nil
    private let appearance = Appearance(isTodayButton: false, headerType: .leading)
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                HStack {
                    GECalendar(selectedDate: $date, appearance: appearance)
                        .padding(.vertical)
                    
                    // Issue...
                    if date != nil && date != lastDate {
                        ZStack {
                            CalendarIssueView(title: "이슈1")
                            
                            
                            HStack {
                                Color.black.frame(width: 1)
                                Spacer()
                            }
                        } .frame(width: geo.size.width / 3)
                    }
                    
                }
                
                HStack {
                    Color.black.frame(width: 1)
                    Spacer()
                }
            }
        }.background(Color(NSColor.textBackgroundColor)).ignoresSafeArea()
        .padding(.trailing, 70)
    }
}

struct CalendarIssueView: View {
    @State private var amount = 50.0
    
    let title: String
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text(title)
                Spacer()
                Image(system: .edit)
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
                
                Text("이슈 진행도")
                HStack {
                    Button(action: {
                        if amount > 0 {
                            amount -= 5
                        }
                    }, label: {
                        Image(system: .minus)
                    }).buttonStyle(PlainButtonStyle())
                    
                    ProgressView(value: amount, total: 100)
                    
                    Button(action: {
                        if amount < 100 {
                            amount += 100
                        }
                    }, label: {
                        Image(system: .plus)
                    }).buttonStyle(PlainButtonStyle())
                }
                
            }
            
            VStack(alignment: .leading, spacing: 3) {
                Text("이슈 대상자")
                Text("비어 있음").foregroundColor(.gray)
            }
            
            Spacer()
            
        }.padding()
        .padding(.leading, 10)
        .background(Color(NSColor.textBackgroundColor))
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
