//
//  UserNotificationManager.swift
//  UserLocalNotification
//
//  Created by Eugene Kurilenko on 11/8/16.
//  Copyright © 2016 Eugene Kurilenko. All rights reserved.
//

import UIKit
import UserNotifications
import CoreLocation

enum AttachmentType {
    case image
    case imageGif
    case audio
    case video
}

class UserNotificationManager: NSObject {
    
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    static let shared = UserNotificationManager()
    
    func registerNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { (granted, error) in
            // handle error
        }
    }
    
    //MARK: - Add Default Notification
    
    func addNotificationWithTimeIntervalTriger() {
        
        let content = UNMutableNotificationContent()
        content.title = "Title"
        content.subtitle = "Subtitle"
        content.body = "Body"
        //content.badge = 1
        content.sound = UNNotificationSound.default()
        
        let triger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "TimeInterval", content: content, trigger: triger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            // handle error
        }
        
    }
    
    func addNotificationWithCalendarTriger() {
        
        let content = UNMutableNotificationContent()
        content.title = "Title"
        content.subtitle = "Subtitle"
        content.body = "Body"
        //content.badge = 1
        content.sound = UNNotificationSound.default()
        
        var components = DateComponents()
        components.hour = 11
        components.minute = 53
        
        let triger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: "Calendar", content: content, trigger: triger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            // handle error
        }
        
    }
    
    func addNotificationWithLocationTriger() {
        
        let content = UNMutableNotificationContent()
        content.title = "Title"
        content.subtitle = "Subtitle"
        content.body = "Body"
        //content.badge = 1
        content.sound = UNNotificationSound.default()
        
        let center = CLLocationCoordinate2DMake(50.25005892, 28.66680086)
        let region = CLCircularRegion(center: center, radius: 1000, identifier: "CircularRegion")
        region.notifyOnEntry = false
        region.notifyOnExit = true
        
        let triger = UNLocationNotificationTrigger(region: region, repeats: true)
        let request = UNNotificationRequest(identifier: "Location", content: content, trigger: triger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            // handle error
        }
        
    }
    
    //MARK: - Add Notification With Attachment
    
    func addNotificationWithAttachment(type: AttachmentType) {
        
        var contentSubtitle = ""
        var url: URL?
        
        switch type {
        case .image:
            contentSubtitle = "Subtitle Image"
            url = Bundle.main.url(forResource: "dance1", withExtension: "jpg")
        case .imageGif:
            contentSubtitle = "Subtitle Image GIF"
            url = Bundle.main.url(forResource: "dance", withExtension: "gif")
        case .audio:
            contentSubtitle = "Subtitle Audio"
            url = Bundle.main.url(forResource: "skyrunning", withExtension: "wav")
        case .video:
            contentSubtitle = "Subtitle Video"
            url = Bundle.main.url(forResource: "Eric", withExtension: "mp4")
        }
        
        let content = contentWith(contentSubtitle)
        
        do {
            let attachment = try UNNotificationAttachment(identifier: "attachment", url: url!, options: nil)
            content.attachments = [attachment]
            addDelayNotificationWith(content)
        } catch {
           print("Make attachment error!")
        }
        
    }
    
    //MARK: - Add Notification with Action
    
    func setCategories() {
        
        let action1 = UNNotificationAction(identifier: "action1", title: "Action 1", options: .authenticationRequired)
        let action2 = UNNotificationAction(identifier: "action2", title: "Start the App", options: .foreground)
        
        let category1 = UNNotificationCategory(identifier: "category1", actions: [action1, action2], intentIdentifiers: [], options: [])
        
        let action3 = UNNotificationAction(identifier: "action3", title: "Red Style", options: .destructive)
        let action4 = UNNotificationAction(identifier: "action4", title: "Unlock and Delete", options: [.authenticationRequired, .destructive])
        
        let category2 = UNNotificationCategory(identifier: "category2", actions: [action3, action4], intentIdentifiers: [], options: [])
        
        let action5 = UNTextInputNotificationAction(identifier: "action5", title: "Title", options: .foreground, textInputButtonTitle: "Send", textInputPlaceholder: "Enter something")
        
        let category3 = UNNotificationCategory(identifier: "category3", actions: [action5], intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([category1, category2, category3])
        
    }
    
    func addNotificationWithCategory1() {
        let content = contentWith("Category 1")
        content.categoryIdentifier = "category1"
        addDelayNotificationWith(content)
    }
    
    func addNotificationWithCategory2() {
        let content = contentWith("Category 2")
        content.categoryIdentifier = "category2"
        addDelayNotificationWith(content)
    }
    
    func addNotificationWithCategory3() {
        let content = contentWith("Category 3")
        content.categoryIdentifier = "category3"
        addDelayNotificationWith(content)
    }
    
    //MARK: - Add notification with Custom UI
    
    func addLocalCustomUI() {
        let content = UNMutableNotificationContent()
        content.title = "Title"
        content.subtitle = "Subtitle"
        content.body = "Body"
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = "categoryCustomUI"
        
        let url = Bundle.main.url(forResource: "dance2", withExtension: "jpg")
        
        do {
            let attachment = try UNNotificationAttachment(identifier: "attacment", url: url!, options: nil)
            content.attachments = [attachment]
            addDelayNotificationWith(content)
        } catch {
            print("Make attachment error!")
        }
    }
    
    
    func addCustomUIMediaPlay() {
        
        let playAction = UNNotificationAction(identifier: "playAction", title: "Play", options: .authenticationRequired)
        let printAction = UNNotificationAction(identifier: "printAction", title: "Print", options: .authenticationRequired)
        let commentAction = UNTextInputNotificationAction(identifier: "commentAction", title: "Comment", options: .foreground, textInputButtonTitle: "Send", textInputPlaceholder: "Enter text")
        
        let category = UNNotificationCategory(identifier: "categoryCustomUI",
                                              actions: [playAction, printAction, commentAction],
                                              intentIdentifiers: [],
                                              options: .customDismissAction)
        
        UNUserNotificationCenter.current().setNotificationCategories([category])

    }
    
    //MARK: - Private
    
    private func contentWith(_ subTitle: String) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "Title"
        content.subtitle = subTitle
        content.body = "Body"
        //content.badge = 1
        content.sound = UNNotificationSound.default()
        
        return content
    }
    
    private func addDelayNotificationWith(_ content: UNMutableNotificationContent) {
       
        let triger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let request = UNNotificationRequest(identifier: "timeInterval", content: content, trigger: triger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            print("Add notification: \(error != nil ? "error" : "success")")
        }
    }
    
}

extension UserNotificationManager: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        completionHandler()
    }
}
