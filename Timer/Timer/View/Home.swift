//
//  Home.swift
//  Timer
//
//  Created by Nick Theodoridis on 12/2/23.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject var timerModel: TimerModel
    
    @State private var isPressed = false

    var body: some View {
        VStack{
            GeometryReader{proxy in
                VStack(spacing: 15){
                    ZStack{
                        Circle().stroke(Color("DarkGray"),lineWidth: 2)
                        
                        Circle()
                            .trim(from: 0 ,to: timerModel.progress)
                            .stroke(Color("Orange"),lineWidth: 2)
                            .animation(.spring(), value: timerModel.progress)
                        
                        
                        GeometryReader{ proxy in
                            let size = proxy.size
                            
                            Circle()
                                .fill(Color("Orange"))
                                .frame(width: 6,height: 6)
                                .frame(width: size.width , height: size.height,alignment: .center)
                                .offset(x: size.height/2)
                                .rotationEffect(.init(degrees: timerModel.progress * 360))
                                .animation(.spring(), value: timerModel.progress)
                        }
                        
                        Text(timerModel.timerStringValue)
                            .font(.custom("TerminaTest-Thin", size: 40))
                            .rotationEffect(.init(degrees: 90))
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
                                
                        }.scaleEffect(isPressed ? -0.1: 1.0)
                    }.background{
                        Circle().stroke(!timerModel.isStarted ? Color("Orange"): Color("DarkGray"),lineWidth: 2)
                    }
                    
                }.frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .center)
                    .pressEvents{
                        withAnimation(.easeIn(duration: 0.2)){
                            isPressed = true
                        }
                    }onRelease: {
                        withAnimation{
                            isPressed = false
                        }
                    }
                
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
        VStack(spacing: 20){
            Text("Add New Timer")
                .font(.custom("TerminaTest-Regular", size:16))
                .foregroundColor(.white)
                .padding(.top,10)
         
            HStack(spacing: 12){
                VStack(alignment: .center){
                    Text("hr").font(.custom("TerminaTest-Regular", size:16))
                    HStack{
                        Text("\(timerModel.hours)")
                            .font(.custom("TerminaTest-Thin", size: 24))
                            .foregroundColor(.white).padding(.horizontal,20).padding(.vertical,12)
                            .background{
                                if timerModel.hours == 0
                                {
                                    Circle().stroke( Color("DarkGray") ,lineWidth: 2).frame(width: 50,height: 50)
                                }
                                else{
                                    Circle().stroke( Color("Orange") ,lineWidth: 2).frame(width: 50,height: 50)
                                }
                            }
                            .contextMenu{
                                ContexMenuOptions(maxValue: 12){ value in
                                    timerModel.hours = value
                                }
                            }

                        
                    }
                   
                }
                
                VStack(alignment: .center){
                    Text("min").font(.custom("TerminaTest-Regular", size:16))
                    HStack{
                        Text("\(timerModel.minutes)")
                            .font(.custom("TerminaTest-Thin",size: 24))
                            .foregroundColor(.white).padding(.horizontal,20).padding(.vertical,12)
                            .background{
                                if timerModel.minutes == 0
                                {
                                    Circle().stroke( Color("DarkGray") ,lineWidth: 2).frame(width: 50,height: 50)
                                }
                                else{
                                    Circle().stroke( Color("Orange") ,lineWidth: 2).frame(width: 50,height: 50)
                                }
                            }
                            .contextMenu{
                                ContexMenuOptions(maxValue: 60){ value in
                                    timerModel.minutes = value
                                }
                            }
                    }
                    
                }
                
                VStack(alignment: .center){
                    Text("sec").font(.custom("TerminaTest-Regular", size:16))
                    Text("\(timerModel.seconds)")
                        .font(.custom("TerminaTest-Thin", size: 24))
                        .foregroundColor(.white).padding(.horizontal,20).padding(.vertical,12)
                        .background{
                            if timerModel.seconds == 0
                            {
                                Circle().stroke( Color("DarkGray") ,lineWidth: 2).frame(width: 50,height: 50)
                            }
                            else{
                                Circle().stroke( Color("Orange") ,lineWidth: 2).frame(width: 50,height: 50)
                            }
                        }
                        .contextMenu{
                            ContexMenuOptions(maxValue: 60){ value in
                                timerModel.seconds = value
                            }
                        }
                }
            }
            .padding(.top,10).padding(.bottom,10)
            
            Button{
                timerModel.startTimer()
            }label: {
                Text("Save")
                    .font(.custom("TerminaTest-Regular", size:15))
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .padding(.horizontal,100)
                    .background{
                        Capsule().fill(Color("Orange")).frame(width: 107,height: 33)
                    }
            }
            .disabled(timerModel.seconds == 0)
            .opacity(timerModel.seconds == 0  ? 0.5 : 1)
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
