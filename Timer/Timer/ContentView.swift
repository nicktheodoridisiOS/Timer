//
//  ContentView.swift
//  Timer
//
//  Created by Nick Theodoridis on 11/2/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var timerModel: TimerModel
    var body: some View {
        Home().environmentObject(timerModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
