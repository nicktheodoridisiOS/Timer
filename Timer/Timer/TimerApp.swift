//
//  TimerApp.swift
//  Timer
//
//  Created by Nick Theodoridis on 11/2/23.
//

import SwiftUI

@main
struct TimerApp: App {
    @StateObject var  timerModel: TimerModel = .init()
    
    @Environment(\.scenePhase) var phase
    
    @State var lastActiveTimeStamp: Date  = Date()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(timerModel)
        }
        .onChange(of: phase){ newValue in
            if timerModel.isStarted{
                if newValue == .background{
                    lastActiveTimeStamp = Date()
                }
                
                if newValue == .active {
                    let  currentTimeStampDiff =  Date().timeIntervalSince(lastActiveTimeStamp)
                    if timerModel.totalSeconds - Int(currentTimeStampDiff) <=  0{
                        timerModel.isStarted = false
                        timerModel.totalSeconds = 0
                        timerModel.isFinished = true
                    }else{
                        timerModel.totalSeconds -= Int(currentTimeStampDiff)
                    }
                }
            }
            
        }
    }
}
