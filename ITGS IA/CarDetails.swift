//
//  CarDetails.swift
//  ITGS IA
//
//  Created by Muhammad Riyan on 04/10/2020.
//  Copyright © 2020 Muhammad Riyan. All rights reserved.
//

import SwiftUI


struct CarDetails: View {
    let car: Car
    @ObservedObject var profiles: Profiles
    
    @State private var showingAddMaintenance = false
    
    @State private var showingAcionSheet = false
    
    @State private var notes = ""
    
    struct CarMaintenance: Hashable{
        let chassisNumber: String
        let carCheckupDate: Date
        let carCategory: String
        let carLocation: String
        let carTechnician: String
        let carStatus: Bool
    }
    
    let carMaintenance: [CarMaintenance]
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
            VStack(alignment: .leading){
                HStack {
                    Text ("Chassis Number")
                        .font(.headline)
                    
                        Spacer()
                    Text("\(car.chassisNumber)")
                        .font(.subheadline)
                 
                }.padding(.bottom, 5)
                
                HStack  {
                    Text("Model Year")
                        .font(.headline)
                        .padding(.bottom)
                    Spacer()
                    Text(String(car.modelYear))
                        .font(.subheadline)
                        .padding(.bottom)
                    
                }
               
                HStack {
                    Text("Maintenance")
                        .font(.largeTitle)
                        .bold()
                
                    Spacer()
                    Button (action:{
                        self.showingAddMaintenance = true
                    }){
                        Image(systemName: "plus")
                    }
                }
                
                    Text("Upcoming Checkup")
                        .font(.system(size: 20))
                        .bold()
                        .padding(.bottom)
                
                ForEach (carMaintenance, id:\.self) { maintenance in
                    if Date() < maintenance.carCheckupDate {
                        VStack(alignment: .leading) {
                            HStack{
                                Text("\(dateFormatter(maintenance.carCheckupDate))")
                                    .font(.system(size: 22))
                                    .bold()
                                Spacer()
                                Image(systemName: "location.fill")
                                Text ("\(maintenance.carLocation)")
                                    .font(.subheadline)
                            }
                            HStack {
                                VStack(alignment: .leading) {
                                    HStack{
                                        Image (systemName: "person.circle")
                                            .padding(.trailing)
                                        Text("\(maintenance.carTechnician)")
                                    }
                                    HStack {
                                        Image(systemName: "wrench")
                                            .padding(.trailing)
                                        Text("\(maintenance.carCategory)")
                                    }
                                }
                                Spacer()
                                Text("\(timeleft(maintenance.carCheckupDate)) Days Left")
                                    .font(.system(size: 15))
                                    .bold()
                            }
                            
                           
                        }
                        .padding()
                        .frame(maxWidth: geometry.size.width)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.secondary, lineWidth: 2))
                        
                    }
                }
                Text("Previous Record")
                    .font(.system(size: 20))
                    .bold()
                    .padding(.top)
                    .padding(.bottom)
                ForEach (carMaintenance, id:\.self) { maintenance in
                    if Date() > maintenance.carCheckupDate {
                        VStack(alignment: .leading) {
                            HStack{
                                Text("\(dateFormatter(maintenance.carCheckupDate))")
                                    .font(.system(size: 22))
                                    .bold()
                                Spacer()
                                Image(systemName: "location.fill")
                                Text ("\(maintenance.carLocation)")
                                    .font(.subheadline)
                            }
                            HStack {
                                VStack(alignment: .leading) {
                                    HStack{
                                        Image (systemName: "person.circle")
                                            .padding(.trailing)
                                        Text("\(maintenance.carTechnician)")
                                    }
                                    HStack {
                                        Image(systemName: "wrench")
                                            .padding(.trailing)
                                        Text("\(maintenance.carCategory)")
                                    }
                                }
                                Spacer()
                                if maintenance.carStatus {
                                    Text("Done")
                                        .padding(.leading)
                                        .padding(.trailing)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.secondary, lineWidth: 2))
                                    .foregroundColor(.green)
                                } else {
                                    Text("Pending")
                                        .padding(.leading)
                                        .padding(.trailing)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.secondary, lineWidth: 2))
                                    .foregroundColor(.red)
                                }
                                
                                Button (action:{
                                    for index in 0 ..< profiles.maintenance.count {
                                        if maintenance.chassisNumber == car.chassisNumber && maintenance.carCheckupDate == profiles.maintenance[index].checkupDate{
                                            profiles.maintenance[index].status = true
                                        }
                                    }
                                }){
                                    Image(systemName: "checkmark.square")
                                }
                                
                            }
                            
                           
                        }
                        .padding()
                        .frame(maxWidth: geometry.size.width)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.secondary, lineWidth: 2))
                    }
                    
                }
                Spacer()
            }
            .padding()
                
        }
    }
        .sheet(isPresented: $showingAddMaintenance) {
            AddMaintenance(car: car, profiles: profiles)
        }
        .navigationBarItems(trailing: NavigationLink(destination: MaintenanceList(profiles: profiles, car: car)){
            Image(systemName: "trash")
        })
            .navigationBarTitle(car.carName)
        
        
    }
    func timeleft(_ checkUP: Date)-> Int {
        let components = Calendar.current.dateComponents([.day, .month, .year], from: checkUP)
        let month = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334]
        let year = (components.year ?? 0) * 365
        let months = (components.month ?? 0)
        let day = components.day ?? 0
        let componentsNow = Calendar.current.dateComponents([.day, .month, .year], from: Date())
        let yearNow = (componentsNow.year ?? 0) * 365
        let monthsNow = (componentsNow.month ?? 0)
        let dayNow = componentsNow.day ?? 0
        
        let time = (day - dayNow) + (month[months-1] - month[monthsNow-1]) + (year - yearNow)
        
        return time
    }
    
    func dateFormatter(_ date: Date)-> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: "en_US")
        let formattedDate = formatter.string(from: date)
        
        return formattedDate
    }
    init (profiles: Profiles, car: Car){
        self.car = car
        self.profiles = profiles
        
        var matches = [CarMaintenance]()
        
        for maintenance in profiles.maintenance {
            if maintenance.chassisNumber == car.chassisNumber {
                matches.append(CarMaintenance(chassisNumber: maintenance.chassisNumber, carCheckupDate: maintenance.checkupDate, carCategory: maintenance.category, carLocation: maintenance.location, carTechnician: maintenance.technician, carStatus: maintenance.status))
            }
        }
        self.carMaintenance = matches
    }
     
}

struct CarDetails_Previews: PreviewProvider {
    static var previews: some View {
        let car = Car(carName: "moco", chassisNumber: "98689", modelYear: 2020, notes: "")
        CarDetails(profiles: Profiles(), car: car)
    }
}
