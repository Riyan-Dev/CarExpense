//
//  AddCar.swift
//  ITGS IA
//
//  Created by Muhammad Riyan on 19/06/2020.
//  Copyright © 2020 Muhammad Riyan. All rights reserved.
//

import SwiftUI

struct AddCar: View {
    @Environment(\.presentationMode) var presentationMode
        @ObservedObject var profiles: Profiles
    
        @State private var addType = 2
        
        static let types = ["Car","Technician"]
    
    
        @State private var carName = ""
        @State private var chassisNumber = ""
        @State private var modelYear = 0
    
        @State private var name = ""
        @State private var category = ""
        @State private var contact = ""
       
        
        @State private var alertTitle = ""
        @State private var alertMessage = ""
        @State private var showAlert = false

        var body: some View {
            NavigationView {
                Form {
                    Section {
                    Picker ("Priority", selection: $addType) {
                        ForEach (0..<2) {
                            Text("\(AddCar.types[$0])")
                        }
                    }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    if addType == 0 {
                        Section(header: Text ("Car Name")) {
                            TextField ("", text: $carName)
                            
                        }
                        Section(header: Text ("Chassis Number")) {
                            TextField("", text: $chassisNumber)
                        }
                        Section(header: Text ("Model Year")) {
                            
                            Picker ("", selection: $modelYear){
                                ForEach( 1990 ..< 2030) { year in
                                    Text(String(year))
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                        }
                    }
                    else if addType == 1 {
                        Section(header: Text ("Name")) {
                            TextField ("", text: $name)
                            
                        }
                        Section(header: Text ("Category")) {
                            TextField("", text: $category)
                        }
                        Section(header: Text ("Contact No.")) {
                            TextField("", text: $contact)
                        }
                    }
                }
                .navigationBarTitle("New Item")
                .navigationBarItems(trailing: Button("save") {
                    if self.addType == 0 {
                    self.AppendingCar()
                    }
                    else if self.addType == 1 {
                        self.AppendingTechnician()
                    }
                })
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
        }
        
        func AppendingCar () {
            guard repition(chassisNumber: chassisNumber) else {
                Error(title: "Repitition", message: "Application Already exists", Show: true)
                return
            }
            guard missingInfo(carName: carName, chassisNumber: chassisNumber) else {
                Error(title: "Invalid Information", message: "You have entered insufficient information, Please review the form", Show: true)
                return
            }
            let car = Car(carName: self.carName, chassisNumber: self.chassisNumber, modelYear: (self.modelYear + 1990), notes: "" )
            self.profiles.cars.append(car)
            self.presentationMode.wrappedValue.dismiss()
        }
        
        func Error(title: String, message: String, Show: Bool) {
                alertTitle = title
                alertMessage = message
                showAlert = true
        }
        
        func repition(chassisNumber: String) -> Bool {
            for index in 0 ..< profiles.cars.count {
                if chassisNumber == profiles.cars[index].chassisNumber {
                    return false
                }
            }
             return true
        }
        
        func missingInfo (carName: String, chassisNumber: String) -> Bool {
            if carName == "" || chassisNumber == "" {
                return false
            }
            return true
        }
    
    func AppendingTechnician () {
        guard repitionT(contact: contact) else {
            Error(title: "Repitition", message: "Application Already exists", Show: true)
            return
        }
        guard missingInfoT(name: name, contact: contact, category: category) else {
            Error(title: "Invalid Information", message: "You have entered insufficient information, Please review the form", Show: true)
            return
        }
        let technician = Technician(name: name, category: category, contact: contact)
        self.profiles.technicians.append(technician)
        self.presentationMode.wrappedValue.dismiss()
    }
    func repitionT(contact: String) -> Bool {
        for index in 0 ..< profiles.technicians.count {
            if contact == profiles.technicians[index].contact {
                return false
            }
        }
         return true
    }
    
    func missingInfoT (name: String, contact: String, category: String) -> Bool {
        if name == "" || contact == "" || category == "" {
            return false
        }
        return true
    }
        
    }

struct AddCar_Previews: PreviewProvider {
    static var previews: some View {
        AddCar(profiles: Profiles())
    }
}
