//
//  AddExpense.swift
//  ITGS IA
//
//  Created by Muhammad Riyan on 07/10/2020.
//  Copyright © 2020 Muhammad Riyan. All rights reserved.
//

import SwiftUI

struct AddExpense: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var profiles: Profiles
    
    let car: Car
    
    @State private var month = 0
    @State private var petrolPrice = 90.00
    @State private var Litres = ""
    @State private var Maintenance = ""
    @State private var year = 2020
    
    let months = ["January", "Febuaray", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var litres: Int {
        let lit = Int(Litres.self) ?? 0
        
        return lit
    }
    var maintenance: Int {
        let maintenance1 = Int(self.Maintenance) ?? 0
        
        return maintenance1
    }
    
    
    var totalExpense: Int {
        let TotalExpense = (litres * (Int(petrolPrice))) + maintenance
        
        return TotalExpense
    }
    
    var body: some View {
        NavigationView {
            Form {
                Picker ("", selection: $month) {
                    ForEach(0 ..< 12){
                        Text("\(months[$0])")
                    }
                }
                Stepper (value: $year, in: 2019 ... 2030, step: 0001) {
                    Text(String(year))
                }
                Stepper (value: $petrolPrice, in: 70 ... 120, step: 0.1) {
                    Text("\(petrolPrice, specifier: "%g")")
                }
                TextField ("Entre Litres", text: $Litres)
                    .keyboardType(.decimalPad)
                TextField ("Entre Maintenece Cost", text: $Maintenance)
                    .keyboardType(.decimalPad)
                    
                
            }
            .navigationBarTitle("New Expense")
            .navigationBarItems(trailing: Button("save") {
                self.appendingExpense()
            })
        }
    }
    
    func appendingExpense() {
        var found = false
        for index in 0 ..< profiles.monthlyExpenses.count {
            if profiles.monthlyExpenses[index].chassisNumber == car.chassisNumber && profiles.monthlyExpenses[index].month == self.months[month] && profiles.monthlyExpenses[index].year == self.year {
                profiles.monthlyExpenses[index].litres += litres
                profiles.monthlyExpenses[index].maintenance += maintenance
                profiles.monthlyExpenses[index].totalExpense += totalExpense
                found = true
                
            }
        }
        if found {
            self.presentationMode.wrappedValue.dismiss()
        } else {
            let monthlyExpense = Monthlyexpense(chassisNumber: car.chassisNumber, month: self.months[month], year: self.year, totalExpense: self.totalExpense, maintenance: self.maintenance, litres: self.litres)
            self.profiles.monthlyExpenses.append(monthlyExpense)
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct AddExpense_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
