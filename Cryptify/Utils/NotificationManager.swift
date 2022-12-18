//
//  NotificationManager.swift
//  Cryptify
//
//  Created by Jan Babák on 16.12.2022.
//

import Foundation
import UserNotifications
import SwiftUI

//manager for local notifications, singleton class
final class NotificationManager {
    
    static let shared = NotificationManager()
    static let notificationsOnUserDefaultsKey = "notificationsOn"
    static let morningReminderCreatedUserDefaultsKey = "notificationSet"
    
    private var badgeCount = 0
    private var notificationRequests: [UNNotificationRequest] = []
    
    @AppStorage(NotificationManager.notificationsOnUserDefaultsKey) var notificationsOn = true
    @AppStorage(NotificationManager.morningReminderCreatedUserDefaultsKey) var morningReminderCreated = false
    
    private init() {} //sigleton hasn't accessible constructor
    
    //request authorization, clear notification badge and schedule morning reminder
    func setUp() {
        requestAuthorization()
        clearNotificationBadge()
        cancelAllNotifications()
        cretateMorningReminder()
    }
    
    //ask user to allow notifications
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in
            if let error = error {
                print("[REQUEST_NOTIFICATION_ERROR]", error.localizedDescription)
            }
        }
    }
    
    //if user has notification enabled in the app, schedule local notification
    func scheduleNotification(title: String, body: String, dateComponents: DateComponents) {
        guard notificationsOn else { return }
        
        badgeCount += 1
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.badge = badgeCount as NSNumber
        content.sound = .default
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        notificationRequests.append(request)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    //if user has notification enabled in the app, creates reminder, which remids user to open the app at 9 AM
    private func cretateMorningReminder() {
        //if morning reminder wasn't created, create it
        if morningReminderCreated { return }
        
        var dateComponents = DateComponents()
        dateComponents.hour = 9
        dateComponents.minute = 0
        
        scheduleNotification(
            title: "Markets are changing!",
            body: "Don't forget to checkout crypto prices!",
            dateComponents: dateComponents
        )
        
        morningReminderCreated = true
    }
    
    func clearNotificationBadge() {
        UIApplication.shared.applicationIconBadgeNumber = 0
        badgeCount = 0
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        morningReminderCreated = false
    }
    
    func notificatiosOnToggled() {
        cancelAllNotifications()
        setUp()
    }
}
