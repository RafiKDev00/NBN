//
//  Home.swift
//  NBN
//
//  Created by RJ  Kigner on 12/31/25.
//

import SwiftUI

struct Home: View {
    
    var onSelectFlight: (() -> Void)? = nil
    var onSelectDocuments: (() -> Void)? = nil
    @StateObject private var app = AppModel.shared
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ApplicationProgressCard()
                
                HStack(spacing: 12) {
                    AdvisorCard()
                    ReserveFlightCard(onSelectFlight: onSelectFlight)
                }

                Documents(onSelectDocuments: onSelectDocuments)
            }
            .padding(.top, 12)
            .padding(.horizontal, 12)
            .padding(.bottom, 12)
            .frame(maxWidth: .infinity, alignment: .top)
        }
        .safeAreaBar(edge: .top){
            NBNHeader()
        }
    }
}

#Preview {
    Home()
}
