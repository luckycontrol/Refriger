//
//  FoodCell.swift
//  refriger
//
//  Created by 조종운 on 2020/02/02.
//  Copyright © 2020 조종운. All rights reserved.
//

import SwiftUI

struct FoodCell: View {
    
    @ObservedObject var viewDatas: ViewDatas
    
    @State var food: [row]
    
    var body: some View {
        
        ForEach(food) { r in
            VStack {
                    
                NavigationLink(destination: FoodInfo(viewDatas: self.viewDatas, name: r.foodName, image: r.image, price: r.price)) {
                        
                    VStack(alignment: .leading) {
                            
                        Image(r.image)
                            .renderingMode(.original)
                            .resizable().frame(height: 320)
                            
                        Text(r.foodName).font(.system(size: 16))
                            .padding(.leading)
                            .padding(.top, 8)
                        }
                    }
                    
                HStack {
                    Text("\(r.price) 원")
                        .font(.system(size: 18, weight: .bold))
                        
                        Spacer()
                }.padding([.horizontal, .bottom])
            }
            .background(Color.white)
            .frame(height: 400)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .shadow(color: .gray, radius: 2, x: 1, y: 1)
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            
        }
    }
        
}

