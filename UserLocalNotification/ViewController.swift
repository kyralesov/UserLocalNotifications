//
//  ViewController.swift
//  UserLocalNotification
//
//  Created by Eugene Kurilenko on 11/8/16.
//  Copyright © 2016 Eugene Kurilenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: Model
    
    let sectionTitle = ["Default Notifications", "Attachment Notification", "Notification with Action", "Notification with Custom UI"]
    
    let data = [
        ["Time Interval Trigger", "Calendar Trigger", "Location Trigger"],
        ["Notification with Image", "Notification with Image Gif", "Notification with Audio", "Notification with Video"],
        ["Set Categories", "Notification with Category 1", "Notification with Category 2", "Notification with Category 3"],
        ["Notification with CustomUI", "Notification with CustomUI and Media Player"]
    ]
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Local Notifications"
        
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifire = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifire, for: indexPath)
        cell.textLabel?.text = data[indexPath.section][indexPath.row]
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                UserNotificationManager.shared.addNotificationWithTimeIntervalTriger()
            case 1:
                UserNotificationManager.shared.addNotificationWithCalendarTriger()
            case 2:
                UserNotificationManager.shared.addNotificationWithLocationTriger()
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                UserNotificationManager.shared.addNotificationWithAttachment(type: .image)
            case 1:
                UserNotificationManager.shared.addNotificationWithAttachment(type: .imageGif)
            case 2:
                UserNotificationManager.shared.addNotificationWithAttachment(type: .audio)
            case 3:
                UserNotificationManager.shared.addNotificationWithAttachment(type: .video)
            default:
                break
            }
        case 2:
            switch indexPath.row {
            case 0:
                UserNotificationManager.shared.setCategories()
            case 1:
                UserNotificationManager.shared.addNotificationWithCategory1()
            case 2:
                UserNotificationManager.shared.addNotificationWithCategory2()
            case 3:
                UserNotificationManager.shared.addNotificationWithCategory3()
            default:
                break
            }
        case 3:
            switch indexPath.row {
            case 0:
                UserNotificationManager.shared.addLocalCustomUI()
            case 1:
                UserNotificationManager.shared.addCustomUIMediaPlay()
            default:
                break
            }
        default:
            break
        }
        
    }
}

