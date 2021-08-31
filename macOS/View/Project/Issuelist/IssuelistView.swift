//
//  Issulist.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/22.
//

import SwiftUI

struct IssuelistView: View {
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Unresolved 2")
                        .padding(.all, 5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .strokeBorder(Color.blue, lineWidth: 2)
                        )
                    
                    Text("For me 2")
                        .padding(.all, 5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .strokeBorder(Color.gray.opacity(0.3))
                        )
                    
                    Text("For me & Unresolved 2")
                        .padding(.all, 5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .strokeBorder(Color.gray.opacity(0.3))
                        )
                    
                    Text("Resolved 2")
                        .padding(.all, 5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .strokeBorder(Color.gray.opacity(0.3))
                        )
                    
                    Spacer()
                    
                    Text("새 이슈")
                        .padding(.all, 5)
                        .background( RoundedRectangle(cornerRadius: 5)
                                        .foregroundColor(.blue))
                }
                
                HStack(spacing: 20) {
                    HStack(spacing: 3) {
                        Text("대상자")
                        Image(system: .downArrow)
                            .font(.caption)
                    }
                    
                    HStack(spacing: 3) {
                        Text("마감기한")
                        Image(system: .downArrow)
                            .font(.caption)
                    }
                    
                    HStack(spacing: 3) {
                        Text("태그")
                        Image(system: .downArrow)
                            .font(.caption)
                    }
                    
                    HStack(spacing: 3) {
                        Image(system: .search)
                        TextField("검색", text: .constant(""))
                            .textFieldStyle(PlainTextFieldStyle())
                    }
                    
                    Spacer()
                }
            }
            
            Divider()
            
            Text("9개의 이슈")
                .padding(.bottom, 10)
            
            ScrollView {
                LazyVStack {
                    ForEach(0...10, id: \.self) { index in
                        HStack(spacing: 20) {
                            HStack {
                                Circle().frame(width: 10, height: 10)
                                Text("이슈 제목")
                            }
                            
                            Spacer()
                            
                            HStack {
                                Circle().frame(width: 20, height: 20)
                                Text("할당자")
                            }
                            
                            Text("09-29")
                                .foregroundColor(.red)
                        }
                        
                    }
                }
            }.padding(.top, 5)
            
            Spacer()
        }
        .padding()
        .padding(.trailing, 70)
        .ignoresSafeArea(.all, edges: .all)
    }
}

struct IssuelistView_Previews: PreviewProvider {
    static var previews: some View {
        IssuelistView()
    }
}
