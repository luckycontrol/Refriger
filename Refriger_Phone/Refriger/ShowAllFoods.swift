//
//  ShowAllFoods.swift
//  Refriger
//
//  Created by 조종운 on 2020/02/16.
//  Copyright © 2020 조종운. All rights reserved.
//

import SwiftUI

struct ShowAllFoods: View {
    
    @FetchRequest(entity: Food.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Food.expiration, ascending: true)]
    ) var foodDatas: FetchedResults<Food>
    
    @Binding var filter: String
    
    @Binding var delete: Bool
    
    var body: some View {
        
        Group {
            if foodDatas.count > 0 {
                ScrollView {
                    if filter == "전체" {
                        ForEach(foodDatas) { food in
                            
                            RefrigerListCell(delete: self.$delete, food: food)
                        }
                    } else {
                        ForEach(foodDatas) { food in
                            if self.filter == food.foodType {
                                RefrigerListCell(delete: self.$delete, food: food)
                            }
                        }
                    }
                }
            } else {
                VStack(spacing: 15) {
                    
                    Text("저장된 식자재가 없습니다.")
                        .font(.system(size: 22, weight: .bold))
                    Text("식자재를 추가하여 유통기한을 관리해보세요!")
                        .font(.system(size: 20, weight: .bold))
                        .multilineTextAlignment(.center)
                }
            }
        }
    }
}
