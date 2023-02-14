//
//  Home.swift
//  Timer
//
//  Created by Nick Theodoridis on 12/2/23.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject var timerModel: TimerModel

    var body: some View {
        VStack{
            GeometryReader{proxy in
                VStack(spacing: 15){
                    ZStack{
                        Circle().stroke(Color("DarkGray"),lineWidth: 2)
                        
                        Circle()
                            .trim(from: 0 ,to: timerModel.progress)
                            .stroke(Color("Orange"),lineWidth: 2)
                        
                        
                        GeometryReader{ proxy in
                            let size = proxy.size
                            
                            Circle()
                                .fill(Color("Orange"))
                                .frame(width: 6,height: 6)
                                .frame(width: size.width , height: size.height,alignment: .center)
                                .offset(x: size.height/2)
                                .rotationEffect(.init(degrees: timerModel.progress * 360))
                        }
                        
                        Text(timerModel.timerStringValue).font(.system(size: 45,weight: .ultraLight)).rotationEffect(.init(degrees: 90))
                            .animation(.none, value: timerModel.progress)
                    }
                    .padding(82)
                    .frame(height: proxy.size.width)
                    .rotationEffect(.init(degrees:-90))
                    .animation(.none, value: timerModel.progress).frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .center)
                    
                    ZStack{
                        Button{
                            if timerModel.isStarted{
                                timerModel.stopTimer()
                                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                            }else{
                                timerModel.addNewTimer = true
                            }
                        }label: {
                            Circle().frame(width: 40,height: 40).padding(4).foregroundColor(!timerModel.isStarted ? Color("Orange"): Color("DarkGray"))
                                
                        }
                    }.background{
                        Circle().stroke(!timerModel.isStarted ? Color("Orange"): Color("DarkGray"),lineWidth: 2)
                    }
                    
                }.frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .center)
                
            }
        }
        .padding()
        .overlay(content: {
            ZStack{
                Color.black.opacity(timerModel.addNewTimer ?  0.25 : 0)
                    .onTapGesture {
                        timerModel.hours = 0
                        timerModel.minutes = 0
                        timerModel.seconds = 0
                        timerModel.addNewTimer = false
                    }
                
                NewTimerView()
                    .frame(maxHeight:  .infinity,alignment: .bottom)
                    .offset(y:timerModel.addNewTimer ? 0 : 400)

            }
            .animation(.easeInOut, value: timerModel.addNewTimer)
        })
        .preferredColorScheme(.dark)
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()){
            _ in
            if timerModel.isStarted{
                timerModel.updateTimer()
            }
        }
        .alert("Time is up",isPresented: $timerModel.isFinished){
            Button("Start New",role: .cancel){
                timerModel.stopTimer()
                timerModel.addNewTimer = true
            }
            
            Button("Close",role: .destructive){
                timerModel.stopTimer()
            }
        }
    }
        
    @ViewBuilder
    func NewTimerView() ->some View  {
        VStack(spacing: 15){
            Text("Add New Timer")
                .font(.title.bold())
                .foregroundColor(.white)
                .padding(.top,10)
            
            HStack(spacing: 15){
                Text("Hours")
                Text("Minutes")
                Text("Seconds")
            }
            
            HStack(spacing: 15){
                
                Text("\(timerModel.hours)")
                    .font(.system(size: 24,weight: .ultraLight))
                    .foregroundColor(.white).padding(.horizontal,20).padding(.vertical,12)
                    .background{
                        Circle().stroke( Color("Orange") ,lineWidth: 2).frame(width: 50,height: 50)
                    }
                    .contextMenu{
                        ContexMenuOptions(maxValue: 12){ value in
                            timerModel.hours = value
                        }
                    }
                
                
                Text("\(timerModel.minutes)")
                    .font(.system(size: 24,weight: .ultraLight))
                    .foregroundColor(.white).padding(.horizontal,20).padding(.vertical,12)
                    .background{
                        Circle().stroke( Color("Orange") ,lineWidth: 2).frame(width: 50,height: 50)
                    }
                    .contextMenu{
                        ContexMenuOptions(maxValue: 60){ value in
                            timerModel.minutes = value
                        }
                    }
                
                
                Text("\(timerModel.seconds)")
                    .font(.system(size: 24,weight: .ultraLight))
                    .foregroundColor(.white).padding(.horizontal,20).padding(.vertical,12)
                    .background{
                        Circle().stroke( Color("Orange") ,lineWidth: 2).frame(width: 50,height: 50)
                    }
                    .contextMenu{
                        ContexMenuOptions(maxValue: 60){ value in
                            timerModel.seconds = value
                        }
                    }
                
            }
            .padding(.top,12)
            
            Button{
                timerModel.startTimer()
            }label: {
                Text("Save")
                    .font(.system(size: 15,weight: .ultraLight))
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .padding(.horizontal,100)
                    .background{
                        Capsule().fill(Color("Orange")).frame(width: 157,height: 37)
                    }
            }
            .disabled(timerModel.seconds == 0)
            .opacity(timerModel.seconds == 0  ? 0.5 : 1)
            .padding(.top)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background{
            RoundedRectangle(cornerRadius: 10,style: .continuous).fill(Color.black).ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    func  ContexMenuOptions(maxValue: Int , onClick: @escaping(Int) -> ()) -> some View{
        ForEach(0...maxValue , id: \.self){ value in
            Button("\(value)"){
                onClick(value)
            }
        }
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(TimerModel())
    }
}
