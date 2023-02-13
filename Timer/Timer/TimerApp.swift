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
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(timerModel)
        }
    }
}
