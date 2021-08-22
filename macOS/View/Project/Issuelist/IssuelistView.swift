//
//  Issulist.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/08/22.
//

import SwiftUI

struct IssuelistView: View {
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("Checklist")
                    Spacer()
                    Text("New Checklist")
                }
                HStack {
                    Text("Owner")
                    Text("검색창")
                    Spacer()
                    HStack(spacing: 0) {
                        Text("Order by")
                        Text("last edited")
                    }
                }
            }
            
            Divider()
            
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
