//
//  ContentView.swift
//  FastingTimer
//
//  Created by dithdyt on 02/10/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var fastingManager = FastingManager()
    
    var title: String {
        switch fastingManager.fastingState{
        case .notStarted:
            return "Let's Get Started!"
        case .fasting:
            return "You are now Fasting"
        case .feeding:
            return "You are now Feeding"
        }
    }
    
    var body: some View {
        ZStack {
            // MARK: Background
            
            Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
                .ignoresSafeArea()
            content
        }
    }
    
    var content: some View {
        ZStack {
            VStack(spacing: 40) {
                // MARK: Title
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(Color(#colorLiteral(red: 0.4, green: 0.5, blue: 1, alpha: 1)))
                
                // MARK: Fasting Plan
                
                Text(fastingManager.fastingPlan.rawValue)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 8)
                    .background(.thinMaterial)
                    .cornerRadius(20)
                
                Spacer()
            }
            .padding()
            
            VStack(spacing: 40) {
                // MARK: Progress Ring
                
                ProgressRing()
                    .environmentObject(fastingManager)
                
                HStack(spacing: 60) {
                    // MARK: Start Time
                    
                    VStack(spacing: 5) {
                        Text(fastingManager.fastingState == .notStarted ? "Start" : "Started")
                            .opacity(0.7)
                        Text(fastingManager.startTime, format: .dateTime.weekday().hour().minute().second())
                            .fontWeight(.bold)
                    }
                    
                    // MARK: End Time
                    
                    VStack(spacing: 5) {
                        Text(fastingManager.fastingState == .notStarted ? "End" : "Ends")
                            .opacity(0.7)
                        Text(fastingManager.endTime, format: .dateTime.weekday().hour().minute().second())
                            .fontWeight(.bold)
                    }
                }
                
                // MARK: Button
                Button {
                    fastingManager.toggleFastingDate()
                } label: {
                    Text(fastingManager.fastingState == .fasting ? "End Fasting" :  "Start Fasting")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)
                        .background(.thinMaterial)
                        .cornerRadius(20)
                }

                
            }
            .padding()
        }
        .foregroundColor(.white)
    }
       
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
