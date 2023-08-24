//
//  Technicians.swift
//  ITGS IA
//
//  Created by Muhammad Riyan on 04/10/2020.
//  Copyright © 2020 Muhammad Riyan. All rights reserved.
//

import SwiftUI

struct Technicians: View {
    @ObservedObject var profiles: Profiles
    
    var body: some View {
        List {
            ForEach (profiles.technicians, id:\.self) {
                Text("\($0.name)")
            }
            .onDelete(perform: deleteTechnician)
        }
    }
    func deleteTechnician (at Offset: IndexSet) {
        profiles.technicians.remove(atOffsets: Offset)
    }
}

struct Technicians_Previews: PreviewProvider {
    static var previews: some View {
        Technicians(profiles: Profiles())
    }
}
