//
//  FoodData+CoreDataProperties.swift
//  
//
//  Created by 조종운 on 2020/02/10.
//
//

import Foundation
import CoreData


extension FoodData: Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FoodData> {
        return NSFetchRequest<FoodData>(entityName: "FoodData")
    }


}
