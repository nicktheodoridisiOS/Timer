//
//  TimerModel.swift
//  Timer
//
//  Created by Nick Theodoridis on 12/2/23.
//

import SwiftUI

class TimerModel: NSObject , ObservableObject , UNUserNotificationCenterDelegate  {
    @Published var progress: CGFloat = 1
    
    @Published var timerStringValue: String = "00:00"
    
    @Published var isStarted: Bool = false
    @Published var addNewTimer: Bool = false
    
    @Published var hours: Int = 0
    @Published var minutes: Int = 0
    @Published var seconds: Int = 0
    
    @Published var totalSeconds: Int  = 0
    @Published var staticTotalSeconds: Int = 0
    
    @Published var isFinished: Bool = false
    
    override init(){
        super.init()
        self.authorizeNotification()
    }
    
    func authorizeNotification(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound,.alert,.badge]) { _, _ in
        }
        
        UNUserNotificationCenter.current().delegate = self
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound , .banner])
    }
    
    func startTimer(){
        withAnimation(.easeInOut(duration: 0.25)){isStarted = true}
        timerStringValue = "\(hours == 0 ? "" :  "\(hours):")\(minutes >= 10 ? "\(minutes)":"0\(minutes)"):\(seconds >= 10 ? "\(seconds)":"0\(seconds)")"
        
        totalSeconds = (hours * 3600) + (minutes * 60) + seconds
        staticTotalSeconds = totalSeconds
        
        addNewTimer = false
        addNotification()
            
    }
    
    func stopTimer(){
        withAnimation{
            isStarted = false
            hours = 0
            seconds = 0
            minutes = 0
            progress = 1
        }
        totalSeconds = 0
        staticTotalSeconds = 0
        timerStringValue = "00:00"
        
    }
    
    func updateTimer(){
        
        totalSeconds -= 1
        progress  = CGFloat(totalSeconds) / CGFloat(staticTotalSeconds)
        progress = (progress<0 ? 0 :progress)
        hours = totalSeconds / 3600
        minutes = (totalSeconds/60) % 60
        seconds = (totalSeconds%60)
        timerStringValue = "\(hours == 0 ? "" :  "\(hours):")\(minutes >= 10 ? "\(minutes)":"0\(minutes)"):\(seconds >= 10 ? "\(seconds)":"0\(seconds)")"
        if hours == 0 && seconds == 0 &&  minutes == 0{
            isStarted = false
            print("Finished")
            isFinished = true
        }
        
    }
    
    func addNotification(){
        let content  = UNMutableNotificationContent()
        content.title = "Timer"
        content.subtitle = "Time is over!"
        content.sound = UNNotificationSound.default
        
        let  request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(staticTotalSeconds), repeats:false))
        
        UNUserNotificationCenter.current().add(request)
        
    }
}
