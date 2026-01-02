//
//  Home.swift
//  NBN
//
//  Created by RJ  Kigner on 12/31/25.
//

import SwiftUI

struct Home: View {
    
    var onSelectFlight: (() -> Void)? = nil
    @StateObject private var app = AppModel.shared
    
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                HomeTextCard(height: 200){
                    Text("Application Progress")
                        .font(.title2)
                        .fontWeight(.semibold)
                } content: {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Your advisor is: \(app.applicantAdvisor)")
                        Text("hello")
                            .multilineTextAlignment(.leading)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding(.top, 12)
                
                
                HStack(spacing: 8) {
                    
                    AdvisorCard()
                    
                    
                    ReserveFlightCard(onSelectFlight: onSelectFlight)
                }
                
                Documents()
            }
               
        }
        .safeAreaBar(edge: .top){
            HStack(alignment: .center){
                Image("NBN_txtonly_Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 50)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 20)
            .background(
                NBNColors.alabaster
                    .shadow(color: NBNColors.bondiBlue.opacity(0.3), radius: 4, y: 4)
                    .ignoresSafeArea()
            )
        }
    }
}

#Preview {
    Home()
}
