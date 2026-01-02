//
//  FlightReservation.swift
//  NBN
//
//  Created by RJ  Kigner on 12/31/25.
//

import SwiftUI

struct FlightReservation: View {
    var body: some View {
        ScrollView{
            VStack{
                Spacer()
                Text("Flight Reservation")
                Spacer()
            }

        }
        .safeAreaBar(edge: .top){
            NBNHeader()
        }
        
    }
}

#Preview {
    FlightReservation()
}
