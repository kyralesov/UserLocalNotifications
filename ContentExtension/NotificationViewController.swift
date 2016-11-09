//
//  NotificationViewController.swift
//  ContentExtension
//
//  Created by Eugene Kurilenko on 11/9/16.
//  Copyright © 2016 Eugene Kurilenko. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import AVFoundation

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var bodyLable: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.preferredContentSize = CGSize(width: self.view.frame.size.width,
                                           height: self.view.frame.size.width / 2)
    }
    
    func didReceive(_ notification: UNNotification) {
        
        let content = notification.request.content
        
        titleLable.text = content.title
        bodyLable.text = content.body
        
        guard let attachment = content.attachments.first else { return }
        
        if attachment.url.startAccessingSecurityScopedResource() {
            let imageData = try? Data.init(contentsOf: attachment.url)
            if let imageData = imageData {
                imageView.image = UIImage(data: imageData)
            }
        }
        attachment.url.stopAccessingSecurityScopedResource()

    }
    
    func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
        
        if response.actionIdentifier == "playAction" {
            
            do {
                try self.player = AVAudioPlayer(contentsOf:
                    URL(fileURLWithPath: Bundle.main.path(forResource: "play", ofType: "m4a")!)
                )
                self.player?.play()
            } catch {
                print("prepare player error!")
            }
            
            completion(.doNotDismiss)
            
        } else if response.actionIdentifier == "printAction" {
            
            bodyLable.text = "Print Text Success"
            completion(.doNotDismiss)
            
        } else if response.actionIdentifier == "commentAction" {
            
            let resp = response as? UNTextInputNotificationResponse
            titleLable.text = resp?.userText
            completion(.dismissAndForwardAction)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3 ) { [unowned self] in
            self.player?.stop()
            self.player = nil
        }
    }

}
