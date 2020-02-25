//
//  SearchBar.swift
//  Refriger
//
//  Created by 조종운 on 2020/02/16.
//  Copyright © 2020 조종운. All rights reserved.
//

import SwiftUI

struct SearchBar: View {
    
    @Binding var sorting: Bool
    
    var body: some View {
        
        HStack {
        
            VStack {
                Button(action: {
                    
                }) {
                    
                    Text("검색").opacity(0.5).padding(.leading, 10)
                    
                    Spacer()
                    
                    Image(systemName: "magnifyingglass")
                        .resizable().frame(width: 15, height: 15)
                        .padding()
                    
                }.foregroundColor(.black)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
            }
            
            Button(action: {
                self.sorting.toggle()
            }) {
                Image(systemName: "slider.horizontal.3")
                    .resizable().frame(width: 15, height: 15)
                    .padding()
            }.foregroundColor(.black)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }.padding()
    }
}
