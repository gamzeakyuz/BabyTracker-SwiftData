//
//  NotificationManager.swift
//  BabyTracker
//
//  Created by gamzeakyuz on 11.12.2025.
//

import Foundation
import UserNotifications

class NotificationManager {
    
    static let shared = NotificationManager()
    
    func requestAuthorization(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,UNAuthorizationOptions.sound]) { grandted, error in
            if grandted {
                print("Notification allowed.")
            } else if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleDailyNotification(identifier: String, title: String, body: String, time: Date, imageName: String? = nil) {
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        if let imageName = imageName, let imageURL = Bundle.main.url(forResource: imageName, withExtension: "png") {
            do {
                let attachment = try UNNotificationAttachment(identifier: imageName, url: imageURL, options: .none)
                content.attachments = [attachment]
            } catch {
                print("Error while adding image: \(error)")
            }
        }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: time)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error while adding notification: \(error)")
            } else {
                print("'\(identifier)' declaration was created for \(components.hour!):\(components.minute!).")
            }
        }
        
    }
    
    func cancelNotification(identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        print("'\(identifier)' has been cancelled.")
    }
    
}
