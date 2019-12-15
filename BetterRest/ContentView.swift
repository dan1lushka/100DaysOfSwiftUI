//
//  ContentView.swift
//  BetterRest
//
//  Created by Daniel Rybak on 24/10/2019.
//  Copyright © 2019 Daniel Rybak. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    var cups = ["1","2","3","4","5","6","7","8","9","10+"]
    
    var bedTime: String {
        let model = SleepCalculator()
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            return formatter.string(from: sleepTime)
        } catch {
            return "Sorry, there was a problem calculating you bedtime."
        }
    }
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                Form {
                    Text("sleep at \(bedTime)")
                        .font(.largeTitle)
                }
                
                Form {
                    Text("When do you want to wake up?")
                        .font(.headline)
                    
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                
                Section {
                    Text("Desired amount of sleep")
                        .font(.headline)
                    
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                }
                
                Form {
                    Text("Daily coffee intake")
                        .font(.headline)
                    
                    Picker(selection: $coffeeAmount, label: Text("Coffee amount")) {
                        ForEach(0 ..< cups.count) {
                            Text("\(self.cups[$0]) cups")
                        }
                    }
                    .labelsHidden()
                }
                    
                .navigationBarTitle("BetterRest")
            }
        }
    }
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
