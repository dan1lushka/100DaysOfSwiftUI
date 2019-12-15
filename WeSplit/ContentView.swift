//
//  ContentView.swift
//  WeSplit
//
//  Created by Daniel Rybak on 10/10/2019.
//  Copyright © 2019 Daniel Rybak. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = ""
    @State private var numberOfPeople = ""
    @State private var tipPercentage = 2
    
    let tipPercentages = [10,15,20,25,0]
    
    var weSplitDict: [String: String] {
        let peopleCount = Double(numberOfPeople) ?? 0
        let tipSelection = Double(tipPercentages[tipPercentage])
        let orderAmount = Double(checkAmount) ?? 0
        
        let tipValue = orderAmount / 100 * tipSelection
        let grandTotal = orderAmount + tipValue
        let amountPerPerson = grandTotal / peopleCount
        
        return ["AmountPP": String(amountPerPerson), "grandTotal": String(grandTotal)]
    }
    
    var tipPercentageValue: Int{
        return tipPercentages[tipPercentage]
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount", text: $checkAmount)
                        .keyboardType(.decimalPad)
                    
                    TextField("Number of people", text: $numberOfPeople)
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("Total tip percentage")) {
                    Picker("Tip Percentage", selection: $tipPercentage) {
                        ForEach(0 ..< tipPercentages.count) {
                            Text("\(self.tipPercentages[$0])%")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Amount per person")) {
                    Text("$\(weSplitDict["AmountPP"] ?? "0")")
                }
                
                Section(header: Text("Grand total")) {
                    Text("$\(weSplitDict["grandTotal"] ?? "0")")
                        .foregroundColor(tipPercentageValue == 0 ? .red : .primary)
                }
            }
            .navigationBarTitle("WeSplit")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
