//
//  AddMaintenance.swift
//  ITGS IA
//
//  Created by Muhammad Riyan on 12/10/2020.
//  Copyright © 2020 Muhammad Riyan. All rights reserved.
//

import SwiftUI

struct AddMaintenance: View {
    @Environment(\.presentationMode) var presentationMode
    let car: Car
    @ObservedObject var profiles: Profiles
    
    @State private var checkupDate = Date()
    @State private var location = ""
    @State private var technician = 0
    @State private var category = 0
    @State private var status = false
    
    let categories = ["Oil Change", "AC service", "Engine Tuning", "Repairment", "6 Months CheckUP"]
    
    let technicians: [String]
    
    
    
    var body: some View {
        NavigationView{
            Form {
                Section (header: Text("CheckUP Date")) {
                    DatePicker ("", selection: $checkupDate, displayedComponents: .date )
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                }
                TextField("Location", text: $location)
                
                Picker ("Category", selection: $category) {
                    ForEach (0 ..< 5) {
                        Text("\(categories[$0])")
                    }
                }
                Picker ("Technician", selection: $technician) {
                    ForEach (0 ..< technicians.count) {
                        Text("\(technicians[$0])")
                    }
                }
            }
            .navigationBarTitle("New Maintenance")
            .navigationBarItems(trailing: Button("Save") {
                let maintenance = Maintenance(chassisNumber: car.chassisNumber, checkupDate: self.checkupDate, category: self.categories[category], location: self.location, technician: self.technicians[technician], status: self.status)
                self.profiles.maintenance.append(maintenance)
                self.presentationMode.wrappedValue.dismiss()
            })
        }
    }
    init (car: Car, profiles: Profiles) {
        self.car = car
        self.profiles = profiles
        
        var technicians: [String] = []
        
        for technician in profiles.technicians {
            technicians.append(technician.name)
        }
        
        self.technicians = technicians
    }
}

struct AddMaintenance_Previews: PreviewProvider {
    static var previews: some View {
        let car = Car(carName: "moco", chassisNumber: "98689", modelYear: 2020, notes: "")
        AddMaintenance(car: car, profiles: Profiles())
    }
}
