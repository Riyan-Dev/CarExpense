//
//  MaintenanceList.swift
//  ITGS IA
//
//  Created by Muhammad Riyan on 13/10/2020.
//  Copyright © 2020 Muhammad Riyan. All rights reserved.
//

import SwiftUI

struct MaintenanceList: View {
    @ObservedObject var profiles: Profiles
    let car: Car
    
    var body: some View {
        
        List{
            ForEach(profiles.maintenance){ maintenance in
                if car.chassisNumber == maintenance.chassisNumber {
                    Text("\(dateFormatter(maintenance.checkupDate))")
                }
            }
            .onDelete(perform: deleteMaintenance)
        }
        .navigationBarItems(trailing: EditButton())
    }
    func deleteMaintenance(at Offset: IndexSet) {
        profiles.maintenance.remove(atOffsets: Offset)
    }
    func dateFormatter(_ date: Date)-> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: "en_US")
        let formattedDate = formatter.string(from: date)
        
        return formattedDate
    }
}

struct MaintenanceList_Previews: PreviewProvider {
    static var previews: some View {
        let car = Car(carName: "moco", chassisNumber: "98689", modelYear: 2020, notes: "")
        MaintenanceList(profiles: Profiles(), car: car)
    }
}
