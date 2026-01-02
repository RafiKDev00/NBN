//
//  FlightReservation.swift
//  NBN
//
//  Created by RJ  Kigner on 12/31/25.
//

import SwiftUI

struct FlightReservation: View {
    @StateObject private var app = AppModel.shared
    
    private var isReadyToBook: Bool {
        app.totalDocuments > 0 && app.completedDocuments >= app.totalDocuments
    }
    
    private var advisorEmail: String {
        app.applicantAdvisorEmail ?? "advisor@nbn.org.il"
    }
    
    var body: some View {
        ScrollView{
            VStack(spacing: 12){
                HomeTextCard {
                    Text(isReadyToBook ? "Ready to book" : "Not ready")
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(isReadyToBook ? NBNColors.bondiBlue : NBNColors.doveGray)
                } content: {
                    VStack(alignment: .leading, spacing: 8) {
                        (Text("Continue uploading documents to submit application and book a flight. For further questions email your advisor at: ")
                         + Text(advisorEmail)
                            .foregroundStyle(NBNColors.bondiBlue))
                            .font(.body)
                        
                        // Hooks for future options/content
                        // Additional booking options can be added here.
                        Text("NOTE TO DEV: Can I scrape flight info off the NBN website for now?")
                    }
                }
                
                // Placeholder area for future flight booking UI
                Spacer(minLength: 0)
            }

            .padding(12)
        }
        .safeAreaBar(edge: .top){
            NBNHeader()
        }
        
    }
}

#Preview {
    FlightReservation()
}
