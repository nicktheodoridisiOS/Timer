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
                        
                        Text(timerModel.timerStringValue).font(.system(size: 45,weight: .light)).rotationEffect(.init(degrees: -90))
                            .animation(.none, value: timerModel.progress)
                    }
                    .padding(82)
                    .frame(height: proxy.size.width)
                    .rotationEffect(.init(degrees:-90))
                    .animation(.none, value: timerModel.progress).frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .center)
                    
                    ZStack{
                        Button{
                            if timerModel.isStarted{
                                
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
                
                NewTimerView().offset(y:timerModel.addNewTimer ? 0 : 400)

            }
            .animation(.easeInOut, value: timerModel.addNewTimer)
        })
        .preferredColorScheme(.dark)
    }
        
    @ViewBuilder
    func NewTimerView() ->some View  {
        VStack(spacing: 15){
            Text("Add New Timer")
                .font(.title.bold())
                .foregroundColor(.white)
                .padding(.top,10)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background{
            RoundedRectangle(cornerRadius: 10,style: .continuous).fill(Color.black).ignoresSafeArea()
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(TimerModel())
    }
}
