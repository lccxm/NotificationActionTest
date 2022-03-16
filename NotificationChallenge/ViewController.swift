//
//  ViewController.swift
//  NotificationChallenge
//
//  Created by Lucca Molon on 15/03/22.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    let notificationCenter = UNUserNotificationCenter.current()
    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var easterEggLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationCenter.delegate = self
        
        requestButton.backgroundColor = .orange
        sendButton.backgroundColor = .orange
        requestButton.layer.cornerRadius = 10
        sendButton.layer.cornerRadius = 10
        easterEggLabel.isHidden = true
        
    }

    @IBAction func RequestButtonAction(_ sender: Any) {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { granted, err in
            if err != nil {
                print("erro")
            } else {
                print("deu bom")
            }
        }
    }
    
    @IBAction func sendButtonAction(_ sender: Any) {
        
        let context = UNMutableNotificationContent()
        
        context.title = "hellou pra voce"
        context.body = "segura a notificação pra inverter as cores ;)"
        context.sound = .default
        context.badge = 1
        
        let invertColorsAction = UNNotificationAction(identifier: "Invert Colors", title: "Invert Colors", options: [])
        
        let actionIdentifier = "actionIdentifier"
        let category = UNNotificationCategory(identifier: actionIdentifier, actions: [invertColorsAction], intentIdentifiers: [], options: [])
        
        notificationCenter.setNotificationCategories([category])
        
        context.categoryIdentifier = actionIdentifier
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: context, trigger: trigger)
        
        notificationCenter.add(request) { err in
            //
        }
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.banner)
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case "Invert Colors":
            requestButton.backgroundColor = requestButton.backgroundColor == .orange ? .magenta : .orange
            sendButton.backgroundColor = sendButton.backgroundColor == .orange ? .magenta : .orange
            easterEggLabel.isHidden.toggle()
        default:
            break
        }
        completionHandler()
    }
}
