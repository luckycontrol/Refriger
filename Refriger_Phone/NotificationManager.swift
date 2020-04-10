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
    
    func sendNotification(message: String) {
        
        var components = DateComponents()
        components.hour = 2
        components.minute = 38
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "유통기한을 확인해주세요."
        notificationContent.body = "현재 유통기한이 " + message + " 식자재가 있습니다."
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let request = UNNotificationRequest(identifier: "안녕, 나의 냉장고", content: notificationContent, trigger: trigger)
        
        userNotificationCenter.add(request) { error in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
}
