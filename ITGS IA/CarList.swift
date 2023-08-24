//
//  CarList.swift
//  ITGS IA
//
//  Created by Muhammad Riyan on 19/06/2020.
//  Copyright © 2020 Muhammad Riyan. All rights reserved.
//

import SwiftUI

struct CarList: View {
    @ObservedObject var profiles: Profiles
    
    var body: some View {
        List {
            ForEach (profiles.cars, id:\.self) { car in
                NavigationLink(
                    destination: CarDetails(profiles: profiles, car: car)) {
                    Text(car.carName)
                }
            }
            .onDelete(perform: deleteCar)
        }
        .navigationBarTitle("Car List")
    }
    func deleteCar (at Offset: IndexSet) {
        profiles.cars.remove(atOffsets: Offset)        
    }
}

struct CarList_Previews: PreviewProvider {
    static var previews: some View {
        CarList(profiles: Profiles())
    }
}
