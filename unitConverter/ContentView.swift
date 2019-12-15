//
//  ContentView.swift
//  unitConverter
//
//  Created by Daniel Rybak on 15/10/2019.
//  Copyright © 2019 Daniel Rybak. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var id = 0
    @State private var convertFrom = ""
    @State private var convertTo = ""
    @State private var amount = ""
    
    var unitSelections = ["meter","km","feet","yard","mile"]
    
    var conversionResult: Double {
        let unitConversionDictioanry = ["meter": 1,
                                        "km": 1000,
                                        "feet": 0.3048,
                                        "yard": 0.91439,
                                        "mile": 1609.34]
        let defaultConversionType = 1.00
        let amountGiven = Double(amount) ?? 0
        
        let defaultFromValue = (unitConversionDictioanry[convertFrom] ?? 0) * defaultConversionType
        let defaultToValue = (unitConversionDictioanry[convertTo] ?? 0) * defaultConversionType
        
        return (defaultFromValue / defaultToValue) * amountGiven
    }
    
    var body: some View {
        
        NavigationView {
            
            Form {
                
                Section(header: Text("From")) {
                    Picker("From", selection: $convertFrom ) {
                        ForEach(0 ..< unitSelections.count) {
                            Text("\(self.unitSelections[$0])")
                                .tag(self.unitSelections[$0])
                        }
                    }
                    .pickerStyle(DefaultPickerStyle())
                    
                    TextField("Enter amount", text: $amount)
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("To")) {
                    Picker("To", selection: $convertTo ) {
                        ForEach(0 ..< unitSelections.count) {
                            Text("\(self.unitSelections[$0])")
                                .tag(self.unitSelections[$0])
                        }
                    }
                    .pickerStyle(DefaultPickerStyle())
                }
                
                Section(header: Text("Result")) {
                    Text("\(conversionResult)")
                }
                
            }
            .navigationBarTitle("Length converter")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



