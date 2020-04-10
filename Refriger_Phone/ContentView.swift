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
    
    @FetchRequest(
        entity: Food.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Food.expiration, ascending: true)]
    ) var foodDatas: FetchedResults<Food>
    
    let notificationManager = NotificationManager()

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
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            if self.foodDatas.count > 0 {
                self.notification()
            }
        }
    }
    
    func notification() {
        // 유통기한 검사 - 지남, 당일, 하루 전, 3일 전, 일주일 전
        var expire: [Int] = [0, 0, 0, 0, 0]
        var expire_str: String = ""
        
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()
        
        let day_1: String = {
            let date = Calendar.current.date(byAdding: .day, value: 1, to: Date())
            return dateFormatter.string(from: date!)
        }()
        
        let day_3: String = {
            let date = Calendar.current.date(byAdding: .day, value: 3, to: Date())
            return dateFormatter.string(from: date!)
        }()
        
        let day_7: String = {
            let date = Calendar.current.date(byAdding: .day, value: 7, to: Date())
            return dateFormatter.string(from: date!)
        }()
        
        for i in foodDatas {
            let foodExpire: String = dateFormatter.string(from: i.expiration!)
            
            // 유통기한이 지났을 경우
            if foodExpire < dateFormatter.string(from: Date()) {
                expire[0] += 1
            }
            // 유통기한 당일
            else if foodExpire == dateFormatter.string(from: Date()) {
                expire[1] += 1
            }
            // 유통기한 하루 전 날
            else if foodExpire == day_1 {
                expire[2] += 1
            }
            // 유통기한 3일 전 날
            else if foodExpire == day_3 {
                expire[3] += 1
            }
            // 유통기한 7일 전 날
            else if foodExpire == day_7 {
                expire[4] += 1
            }
        }
        
        if expire[0] > 0 {
            expire_str += "지난"
        }
        if expire[1] > 0 {
            expire_str += ", 오늘까지"
        }
        if expire[2] > 0 {
            expire_str += ", 하루남은"
        }
        if expire[3] > 0 {
            expire_str += ", 3일남은"
        }
        if expire[4] > 0 {
            expire_str += ", 일주일남은"
        }
        notificationManager.sendNotification(message: expire_str)
    }
}
