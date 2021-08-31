//
//  ContentView.swift
//  Shared
//
//  Created by GoEun Jeong on 2021/08/21.
//

import SwiftUI

struct ContentView: View {
    #if os(iOS)
    var body: some View {
        Home()
    }
    
    #endif
    
    #if os(OSX)
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Home()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .environmentObject(homeViewModel)
                
                if homeViewModel.toast != nil {
                    ZStack {
                        Color.black.opacity(0.5)
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation {
                                    homeViewModel.toast = nil
                                }
                            }
                        
                        switch homeViewModel.toast {
                        case .channelInfo:
                            ChannelInfoView()
                                .padding()
                                .cornerRadius(10)
                                .frame(width: geo.size.width / 1.3, height: geo.size.height / 1.3)
                                .background(Color(NSColor.textBackgroundColor)).ignoresSafeArea()
                        case .channelSearch:
                            ChannelSearchView()
                        case .none:
                            Text("")
                                .opacity(0)
                        }
                    }
                }
            }
        }
    }
    #endif
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
