//
//  MemberView.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/22.
//

import SwiftUI

struct Member: Hashable {
    var name: String
    var status: Bool
    var isMe: Bool
}

let members = [Member(name: "김재원", status: true, isMe: false), Member(name: "김재원2", status: true, isMe: false), Member(name: "김재원3", status: false, isMe: false), Member(name: "김재원4", status: false, isMe: false), Member(name: "정고은", status: true, isMe: true)]

struct MemberView: View {
    //    @ObservedObject var projectVM = ProjectViewModel()
    @Namespace private var animation
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 15) {
                    Text("Teams")
                        .font(.title)
                    
                    Spacer()
                    Button(action: {}, label: {
                        SystemImage(system: .plus)
                            .frame(width: 15, height: 15)
                            .padding(.vertical)
                    })
                }
                
                Text("7 Members")
                
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(members, id: \.self) { member in
                            MemberRow(member: member)
                        }.padding(.vertical, 5)
                    }
                }
                
                Spacer()
            }.padding()
            
            HStack {
                Color.black.frame(width: 1)
                Spacer()
            }
        }.padding(.trailing, 70)
        .background(Color(NSColor.textBackgroundColor)).ignoresSafeArea()
    }
}

struct MemberRow: View {
    let member: Member
    var body: some View {
        HStack {
            ZStack(alignment: .bottomTrailing) {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 100, height: 100)
                
                if member.status {
                   ActiveView()
                } else {
                    InActiveView()
                }
            }
            
            VStack(alignment: .leading) {
              
                Text(member.name)
                Spacer()
                Text("Chat with 재원")
            }
            
            Spacer()
        }.padding()
        .background(
            RoundedRectangle(cornerRadius: 10).foregroundColor(Color(NSColor.windowBackgroundColor))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color.gray.opacity(0.3))
        )
    }
}

struct MemberView_Previews: PreviewProvider {
    static var previews: some View {
        MemberView()
    }
}
