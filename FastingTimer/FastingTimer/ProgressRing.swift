//
//  ProgressRing.swift
//  FastingTimer
//
//  Created by dithdyt on 02/10/23.
//

import SwiftUI

struct ProgressRing: View {
    @EnvironmentObject var fastingManager: FastingManager
    @State var progress = 0.0
    
    let timer = Timer
        .publish(every: 1, on: .main, in: .common)
        .autoconnect()
    var body: some View {
        ZStack{
            //MARK: Placeholder Ring
            
            
            Circle()
                .stroke(lineWidth: 30)
                .foregroundColor(.gray)
                .opacity(0.1)
            
            //MARK: Colored Ring
            
            Circle()
                .trim(from: 0.0, to: min(progress, 1.0))
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [
                            Color.pink,
                            Color.purple,
                            Color.blue,
                            Color.purple,
                            Color.pink
                        ]),
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 15.0, lineCap: .round, lineJoin: .round)
                )
                .rotationEffect((Angle(degrees: 270)))
                .animation(.easeInOut(duration: 1.0), value: progress)
            
            VStack(spacing: 30) {
                if fastingManager.fastingState == .notStarted {
                    //MARK: Upcoming Fast
                    VStack(spacing: 5) {
                        Text("Upcoming Fast")
                            .opacity(0.7)
                        
                        Text("\(fastingManager.fastingPlan.fastingPeriod.formatted()) Hours")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                } else {
                    //MARK: Elapsed Time
                    VStack(spacing: 5) {
                        Text("Elapsed Time")
                            .opacity(0.7)
                        
                        Text(fastingManager.startTime, style: .timer)
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    .padding(.top)
                    
                    //MARK: Remaining Time
                    VStack(spacing: 5) {
                        if !fastingManager.elapsed {
                            Text("Remaining Time")
                                .opacity(0.7)
                        } else {
                            Text("Extra Time")
                                .opacity(0.7)
                            
                        }
                        
                        Text(fastingManager.startTime, style: .timer)
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                }
                
            }
        }
        .frame(width: 250, height: 250)
        .padding()
        .onAppear{
            progress = 1
        }
        .onReceive(timer) { _ in
            fastingManager.track()
        }
    }
}

struct ProgressRing_Previews: PreviewProvider {
    static var previews: some View {
        ProgressRing()
            .environmentObject(FastingManager())
    }
}
