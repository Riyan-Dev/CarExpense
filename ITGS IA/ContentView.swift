//
//  ContentView.swift
//  ITGS IA
//
//  Created by Muhammad Riyan on 19/06/2020.
//  Copyright © 2020 Muhammad Riyan. All rights reserved.
//

import SwiftUI

struct Car: Codable, Identifiable, Hashable{ //car as object
    var id = UUID()
    let carName: String
    let chassisNumber: String
    let modelYear: Int
    var notes: String
}
struct Monthlyexpense: Codable, Hashable, Identifiable {
    var id = UUID()
    let chassisNumber: String
    let month: String
    let year: Int
    var totalExpense: Int
    var maintenance: Int
    var litres: Int
}

struct Maintenance: Codable, Identifiable, Hashable {
    var id = UUID()
    let chassisNumber: String
    let checkupDate: Date
    let category: String
    let location: String
    let technician: String
    var status: Bool
}

struct Technician: Codable, Identifiable, Hashable {
    var id = UUID()
    let name: String
    let category: String
    let contact: String
}
class Profiles: ObservableObject { // to make changes on different modules
    @Published var cars = [Car]() {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(cars) {
                UserDefaults.standard.set(encoded, forKey: "cars")
            }
        }
    }
    @Published var technicians = [Technician]() {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(technicians) {
                UserDefaults.standard.set(encoded, forKey: "technicians")
            }
        }
    }
    @Published var monthlyExpenses = [Monthlyexpense]() {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(monthlyExpenses) {
                UserDefaults.standard.set(encoded, forKey: "monthlyExpense")
            }
        }
    }
    @Published var maintenance = [Maintenance]() {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(maintenance) {
                UserDefaults.standard.set(encoded, forKey: "maintenance")
            }
        }
    }
    init() {
        if let cars = UserDefaults.standard.data(forKey: "cars") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Car].self, from: cars) {
                self.cars = decoded
            }
        } else { self.cars = [] }
        if let technicians = UserDefaults.standard.data(forKey: "technicians") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Technician].self, from: technicians) {
                self.technicians = decoded
            }
        } else { self.technicians = [] }
        if let monthlyExpense = UserDefaults.standard.data(forKey: "monthlyExpense") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Monthlyexpense].self, from: monthlyExpense) {
                self.monthlyExpenses = decoded
            }
        } else { self.monthlyExpenses = [] }
        if let maintenance = UserDefaults.standard.data(forKey: "maintenance") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Maintenance].self, from: maintenance) {
                self.maintenance = decoded
            }
        } else { self.maintenance = [] }
    }
}

struct ContentView: View {
    @ObservedObject var profiles = Profiles()
    @State private var showingAddCar = false
    @State private var showingCarDetails = false
    
    @Environment(\.colorScheme) var colorSceheme
    
    @State private var carName = ""
    @State private var chassisNumber = ""
    @State private var modelYear = 0
  
    
   
    var body: some View {
        GeometryReader{ geometry in
            NavigationView {
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(profiles.cars) { car in
                            Text("\(car.carName)")
                                .font(.title)
                                .bold()
                            ForEach(profiles.maintenance){ maintenance in
                                if Date() < maintenance.checkupDate && car.chassisNumber == maintenance.chassisNumber && timeleft(maintenance.checkupDate) < 60 {
                                    NavigationLink (destination: CarDetails(profiles: profiles, car: car)) {
                                        VStack(alignment: .leading) {
                                            HStack{
                                                Text("\(dateFormatter(maintenance.checkupDate))")
                                                    .font(.system(size: 22))
                                                    .bold()
                                                Spacer()
                                                Image(systemName: "location.fill")
                                                Text ("\(maintenance.location)")
                                                    .font(.subheadline)
                                            }
                                            HStack {
                                                VStack(alignment: .leading) {
                                                    HStack{
                                                        Image (systemName: "person.circle")
                                                            .padding(.trailing)
                                                        Text("\(maintenance.technician)")
                                                    }
                                                    HStack {
                                                        Image(systemName: "wrench")
                                                            .padding(.trailing)
                                                        Text("\(maintenance.category)")
                                                    }
                                                }
                                                Spacer()
                                                Text("\(timeleft(maintenance.checkupDate)) Days Left")
                                                    .font(.system(size: 15))
                                                    .bold()
                                                    .foregroundColor(timeleft(maintenance.checkupDate) < 7 ? .red : .orange)
                                            }
                                            
                                           
                                        }
                                        
                                        .padding()
                                        .frame(maxWidth: geometry.size.width)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.secondary, lineWidth: 2))
                                        .contentShape(Rectangle())
                                        .foregroundColor(colorSceheme == .dark ? .white : .black)
                                        
                                    }
                                }
                            }
                            Spacer()
                        }
                    }
                
                    .padding()
                        .navigationBarTitle("Car Manager")
                            .navigationBarItems(leading: NavigationLink ( destination: Menu(profiles: self.profiles)) {
                                Image(systemName: "square.grid.2x2.fill")
                            },
                        trailing: Button (action: {
                            self.showingAddCar = true
                        }) {
                            Image(systemName: "plus")
                        }
                        )
                    .sheet(isPresented: $showingAddCar) {
                        AddCar(profiles: self.profiles)
                        
                    }
                }
            }
        }
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
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
