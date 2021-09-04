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
    @State private var plusPop = false
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 15) {
                    Text("Teams")
                        .font(.title)
                    
                    Spacer()
                    Button(action: {
                        self.plusPop.toggle()
                    }, label: {
                        SystemImage(system: .plus)
                            .frame(width: 15, height: 15)
                            .padding(.vertical)
                    })
                    .popover(isPresented: $plusPop) {
                        MemberPopView()
                            .padding()
                            .padding()
                    }
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
                Text("DM with 재원")
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

struct MemberPopView: View {
    @State private var isCopied: Bool = false
    
    var body: some View {
        VStack(spacing: 15) {
            Text("프로젝트 코드를 복사해 사람들을 초대해보세요.")
                .foregroundColor(.gray)
            
            HStack(spacing: 15) {
                HStack {
                    ForEach(0..<6, id: \.self) { index in
                        Text(String(index))
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.all, 10)
                            .background(Color.gray.opacity(0.5).cornerRadius(10))
                    }
                }
                
                if isCopied {
                    Image(system: .checkmark)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                withAnimation {
                                    self.isCopied = false
                                }
                            }
                        }
                } else {
                    Image(system: .copy)
                        .frame(width: 10, height: 15)
                        .onTapGesture {
                            let pasteboard = NSPasteboard.general
                            pasteboard.declareTypes([.string], owner: nil)
                            pasteboard.setString("012345", forType: .string)
                            withAnimation {
                                self.isCopied = true
                            }
                        }
                }
            }
        }
    }
}

struct MemberView_Previews: PreviewProvider {
    static var previews: some View {
        MemberView()
        MemberPopView()
    }
}
