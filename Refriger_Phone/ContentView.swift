//
//  ContentView.swift
//  Refriger
//
//  Created by 조종운 on 2020/02/07.
//  Copyright © 2020 조종운. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var session: SessionStore

    var body: some View {
        
        TabView {
            
            RefrigerList()
                .tabItem {
                    Image(systemName: "list.dash").resizable().frame(width: 14, height: 14)
                    Text("식자재 목록").font(.system(size: 16))
                }
            
            Mart()
                .tabItem {
                    Image(systemName: "cart")
                    Text("식자재 주문")
                }
        }.accentColor(.black)
        
    }
}
