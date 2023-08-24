//
//  MonthlyExpense.swift
//  ITGS IA
//
//  Created by Muhammad Riyan on 06/10/2020.
//  Copyright © 2020 Muhammad Riyan. All rights reserved.
//

import SwiftUI


struct MonthlyExpense: View {
    
    let car: Car
    @ObservedObject var profiles: Profiles
    @State private var index = 0
    @State private var showingAddExpense = false
    
    
    struct CarExpense{
        let carTotal: Int
        let carLitre: Int
        let carMonth: String
        let carYear: Int
        let carMaintenence: Int
        let chassisNumber: String
    }
    
    let carExpenses: [CarExpense]
    
    let months: [String]
    let years: [String]
    
    
    var body: some View {
        VStack {
            Form {
                Picker ("Month", selection: $index) {
                    ForEach (0 ..< carExpenses.count){ selection in
                        Text("\(months[selection]), \(years[selection])")
                    }
                }
                .pickerStyle(WheelPickerStyle())
            }
            if carExpenses.count > 0 {
                HStack {
                    Text ("Litres")
                        .font(.headline)
                        .padding()
                    Spacer()
                    Text ("\(carExpenses[index].carLitre) ltrs" )
                        .font(.subheadline)
                        .padding()
                }
                HStack {
                    Text ("Total Expense")
                        .font(.headline)
                        .padding()
                    Spacer()
                    Text ("\(carExpenses[index].carTotal) PKR")
                        .font(.subheadline)
                        .padding()
                }
                HStack {
                    Text ("Maintenance Cost")
                        .font(.headline)
                        .padding()
                    Spacer()
                    Text ("\(carExpenses[index].carMaintenence) PKR")
                        .font(.subheadline)
                        .padding()
                }
                Spacer()
            }
        }
        .navigationBarItems(trailing: HStack{ Button(action: {
            self.showingAddExpense = true
        }){
            Text ("Add Expense")
        }
        
        NavigationLink(destination: ExpenseList(profiles: profiles, car: car)) {
            Image(systemName: "trash")
        }
      
            
        
        })
        
        .sheet(isPresented: $showingAddExpense){
            AddExpense(profiles: profiles, car: car)
        }
        .navigationBarTitle(car.carName)
    }
    
    init (profiles: Profiles, car: Car) {
        self.profiles = profiles
        self.car = car
        
        var matches = [CarExpense]()
        var months:[String] = []
        var years:[String] = []
        
        for expense in profiles.monthlyExpenses {
            if car.chassisNumber == expense.chassisNumber {
                matches.append(CarExpense(carTotal: expense.totalExpense, carLitre: expense.litres, carMonth: expense.month, carYear: expense.year, carMaintenence: expense.maintenance, chassisNumber: expense.chassisNumber))
                
            }
        }
        self.carExpenses = matches
        for expenses in carExpenses {
            let year = String(expenses.carYear)
            months.append(expenses.carMonth)
            years.append(year)
    }
        self.months = months
        self.years = years
    }
    
    
        

        
}

struct MonthlyExpense_Previews: PreviewProvider {
    static var previews: some View {
        let car = Car(carName: "moco", chassisNumber: "98689", modelYear: 2020, notes: "")
        MonthlyExpense(profiles: Profiles(), car: car)
    }
}
