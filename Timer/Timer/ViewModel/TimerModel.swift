//
//  TimerModel.swift
//  Timer
//
//  Created by Nick Theodoridis on 12/2/23.
//

import SwiftUI

class TimerModel: NSObject , ObservableObject  {
    @Published var progress: CGFloat = 1
    
    @Published var timerStringValue: String = "00:00"
    @Published var isStarted: Bool = false
    @Published var addNewTimer: Bool = false
    @Published var hours: Int = 0
    @Published var minutes: Int = 0
    @Published var seconds: Int = 0
}
