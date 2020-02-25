//
//  NotificationManager.swift
//  Refriger
//
//  Created by 조종운 on 2020/02/19.
//  Copyright © 2020 조종운. All rights reserved.
//

import Foundation
import SwiftUI
import UserNotifications

class NotificationManager {
    
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    init() {
        self.requestNotificationAuthorization()
    }
    
    func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
        
        self.userNotificationCenter.requestAuthorization(options: authOptions) { (success, error) in
            if let error = error {
                print("Error: ", error)
            }
        }
    }
    
    func sendNotification(food: String, leftTime: String, hour: Int) {
        
        /// 매일 오전 8시에 알림
        var components = DateComponents()
        components.hour = hour
        components.minute = 0
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "유통기한을 확인해주세요."
        notificationContent.body = "[ \(food) ]의 유통기한이 얼마 남지 않았습니다."
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let request = UNNotificationRequest(identifier: "안녕, 나의 냉장고", content: notificationContent, trigger: trigger)
        
        userNotificationCenter.add(request) { error in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
}
