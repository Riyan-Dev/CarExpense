//
//  ExpenseList.swift
//  ITGS IA
//
//  Created by Muhammad Riyan on 12/10/2020.
//  Copyright © 2020 Muhammad Riyan. All rights reserved.
//

import SwiftUI

struct ExpenseList: View {
    @ObservedObject var profiles: Profiles
    let car: Car
    
    var body: some View {
        List{
            ForEach (profiles.monthlyExpenses) { expense in 
                if car.chassisNumber == expense.chassisNumber {
                    Text ("\(expense.month), \(String(expense.year))")
                }
            }
            .onDelete(perform: deleteExpense)
        }
        .navigationBarItems(trailing: EditButton())
    }
    func deleteExpense (at Offset: IndexSet) {
        profiles.monthlyExpenses.remove(atOffsets: Offset)
    }
}

struct ExpenseList_Previews: PreviewProvider {
    static var previews: some View {
        let car = Car(carName: "moco", chassisNumber: "98689", modelYear: 2020, notes: "") 
        ExpenseList(profiles: Profiles(), car: car)
    }
}
