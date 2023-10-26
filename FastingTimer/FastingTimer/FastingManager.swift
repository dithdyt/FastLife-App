//
//  FastingManager.swift
//  FastingTimer
//
//  Created by dithdyt on 10/10/23.
//

import Foundation

enum FastingState {
    case notStarted
    case fasting
    case feeding
}

enum FastingPlan: String {
    case beginner = "12:12"
    case intermediate = "Start"
    case advanced = "20:4"
    
    var fastingPeriod: Double {
        switch self {
        case .beginner:
            return 12
        case .intermediate:
            return 16
        case .advanced:
            return 20
        }
    }
}

class FastingManager: ObservableObject {
    @Published private(set) var fastingState: FastingState = .notStarted
    @Published private(set) var fastingPlan: FastingPlan = .intermediate
    @Published private(set) var startTime: Date {
        didSet {
            print("scheduledTime", startTime.formatted(.dateTime.month().day().hour().minute().second()))
            if fastingState == .fasting {
                endTime = startTime.addingTimeInterval(fastingTime)
            } else {
                endTime = startTime.addingTimeInterval(feedingTime)
            }
        }
    }
    @Published private(set) var endTime: Date {
        didSet {
            print("endTime", endTime.formatted(.dateTime.month().day().hour().minute().second()))
        }
    }
    
    @Published private(set) var elapsed: Bool = false
    
    var fastingTime: Double {
        return fastingPlan.fastingPeriod
    }
    var feedingTime: Double {
        return 24 - fastingPlan.fastingPeriod
    }
    
    init() {
        let calendar = Calendar.current
        
//        var components = calendar.dateComponents([.year, .month, .day, .hour], from: Date())
//        components.hour = 20
//        print(components)
//
//        let scheduledTime = calendar.date(from: components) ?? Date.now
//        print("scheduledTime", scheduledTime.formatted(.dateTime.month().day().hour().minute().second()))
        
        let components = DateComponents(hour: 20)
        let scheduledTime = calendar.nextDate(after: .now, matching: components, matchingPolicy: .nextTime)!
        print("scheduledTime", scheduledTime.formatted(.dateTime.month().day().hour().minute().second()))
        
        startTime = scheduledTime
        endTime = scheduledTime.addingTimeInterval(FastingPlan.intermediate.fastingPeriod)
    }
    
    func toggleFastingDate() {
        fastingState = fastingState == .fasting ? .feeding : .fasting
        startTime = Date()
    }
    func track() {
        guard fastingState != .notStarted else { return }
        
        print("Now", Date().formatted(.dateTime.month().day().hour().minute().second()))
        
        if endTime >= Date() {
            print("Not Elapsed")
            elapsed = false
        } else {
            print("Elapsed")
            elapsed = true
        }
    }
}
