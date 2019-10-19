//
//  ViewController.swift
//  DoctorApointmentReminder
//
//  Created by Eugene Berezin on 10/19/19.
//  Copyright © 2019 Eugene Berezin. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    
    @IBOutlet var backgroundView: UIImageView!
    
   let register: UIButton = {
       let button = UIButton(type: .system)
       button.setTitle("Register", for: .normal)
       button.setTitleColor(.white, for: .normal)
       button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
       button.backgroundColor = .systemBlue
       button.heightAnchor.constraint(equalToConstant: 44).isActive = true
//       button.widthAnchor.constraint(equalToConstant: 250).isActive = true
       button.layer.cornerRadius = 22
       button.isEnabled = true
       button.translatesAutoresizingMaskIntoConstraints = false
       button.addTarget(self, action: #selector(registerLocal), for: .touchUpInside)
    
       return button
   }()
    
    let schedule: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Schedule notification", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.backgroundColor = .systemBlue
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
//        button.widthAnchor.constraint(equalToConstant: 250).isActive = true
        button.layer.cornerRadius = 22
        button.isEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(scheduleLocal), for: .touchUpInside)
     
        return button
    }()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpButtons()
        
        
       
        // Do any additional setup after loading the view.
    }
    
    
    func setUpButtons() {
        view.addSubview(register)
        view.addSubview(schedule)
        
        NSLayoutConstraint.activate([
            register.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            register.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            register.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            
            schedule.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -190),
            schedule.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            schedule.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30)
            
        
        ])
    }
    
    
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound, .providesAppNotificationSettings, .announcement, .criticalAlert]) { granted, error in
            if granted {
                print("Registered")
            } else {
                print("Failed register")
            }
        }
        
        
    }
    
    @objc func scheduleLocal() {
        registerCategories()
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "You have an appointment"
        content.body = "You have upcoming apointment with your doctor"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 17
        dateComponents.minute = 37
        //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        center.add(request)
        
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Open the app", options: [.foreground, .destructive])
        let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [], options: [.allowAnnouncement, .allowInCarPlay])
        

        center.setNotificationCategories([category])
        
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("Custom data received: \(customData)")
            
            switch response.actionIdentifier {
                   case UNNotificationDefaultActionIdentifier:
                       // the user swiped to unlock
                       print("Default identifier")

                   case "show":
                       // the user tapped our "show more info…" button
                       print("Show more information…")

                   default:
                       break
                   }
            
        }
        completionHandler()
    }

    


}

