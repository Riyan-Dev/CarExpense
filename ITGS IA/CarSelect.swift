//
//  CarSelect.swift
//  ITGS IA
//
//  Created by Muhammad Riyan on 06/10/2020.
//  Copyright © 2020 Muhammad Riyan. All rights reserved.
//

import SwiftUI

struct CarSelect: View {
    @ObservedObject var profiles: Profiles
    var body: some View {
        List {
            ForEach (profiles.cars) { car in
                NavigationLink(
                    destination: MonthlyExpense(profiles: profiles, car: car)) {
                    Text(car.carName)
                }
            }
        }
        .navigationBarTitle("Car Select")
    }
}

struct CarSelect_Previews: PreviewProvider {
    static var previews: some View {
        CarSelect(profiles: Profiles())
    }
}
