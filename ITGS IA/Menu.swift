//
//  Menu.swift
//  ITGS IA
//
//  Created by Muhammad Riyan on 04/10/2020.
//  Copyright © 2020 Muhammad Riyan. All rights reserved.
//

import SwiftUI

struct Menu: View {
    @ObservedObject var profiles: Profiles
    let buttons = ["car","technician", "monthly_expense"]
    
    init(profiles: Profiles) {
        self.profiles = profiles
        
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.systemBlue]
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.gray, .white]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    NavigationLink(destination: CarList(profiles: profiles)) {
                            Image ("car")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: geometry.size.width * 0.4)
                                .padding(5)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 2))
                                .padding()
                    }
                    NavigationLink(destination: Technicians(profiles: profiles)) {
                            Image ("technician")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: geometry.size.width * 0.4)
                                .padding(5)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 2))
                                .padding()
                    }
                    NavigationLink(destination: CarSelect(profiles:  profiles)) {
                            Image ("monthly_expense")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: geometry.size.width * 0.4)
                                .padding(5)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 2))
                                .padding()
                    }
                }
                .navigationBarTitle("Menu")
            }
        }
    }
}

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Menu(profiles: Profiles())
    }
}
