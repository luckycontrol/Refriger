//
//  FoodType.swift
//  refriger
//
//  Created by 조종운 on 2020/02/02.
//  Copyright © 2020 조종운. All rights reserved.
//

import SwiftUI

struct FoodType: View {
    
    @ObservedObject var viewDatas: ViewDatas
    
    @Binding var selectFood: Bool
    
    var body: some View {
        
        ZStack {
        
            HStack {
            
                VStack(alignment: .leading, spacing: 15) {
                    
                    if viewDatas.category == "과일" {
                        
                        ForEach(fruit) { i in
                            
                            Button(action: {
                                self.viewDatas.foodName = i.foodType
                                print(self.viewDatas.foodName)
                                
                                withAnimation {
                                    self.selectFood = false
                                }
                            }) {
                                Text(i.foodType)
                            }
                        }
                    }
                    
                    else if viewDatas.category == "채소" {
                        
                        ForEach(vegetable) { i in
                            
                            Button(action: {
                                self.viewDatas.foodName = i.foodType
                                
                                withAnimation {
                                    self.selectFood = false
                                }
                            }) {
                                Text(i.foodType)
                            }
                        }
                    }
                    
                    else if viewDatas.category == "정육" {
                        
                        ForEach(meat) { i in
                            
                            Button(action: {
                                self.viewDatas.foodName = i.foodType
                                
                                withAnimation {
                                    self.selectFood = false
                                }
                            }) {
                                Text(i.foodType)
                            }
                        }
                    }
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .padding()
    }
}

