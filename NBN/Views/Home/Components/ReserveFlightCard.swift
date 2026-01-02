//
//  ReserveFlightCard.swift
//  NBN
//
//  Created by RJ  Kigner on 1/2/26.
//
import SwiftUI

struct ReserveFlightCard: View {
    @StateObject private var app = AppModel.shared
    var onSelectFlight: (() -> Void)? = nil
    
    var body: some View {
        HomeTextCard(height: 200){
            Text("Reserve Flight")
                .font(.title3)
                .fontWeight(.semibold)
        } content: {
            VStack(alignment: .center, spacing: 0) {
//                Spacer()
                if app.completedDocuments == app.totalDocuments{
                    Text("You are Ready to Schedule a Flight!")
                        Spacer()
                } else {
                    Text("Finish submitting documents for flight approval!")
                    Spacer()
                }
                
                Button {
                    if app.completedDocuments == app.totalDocuments {
                        onSelectFlight?()
                    }
                } label:{
                    Text("schedule flight \(Image(systemName: "chevron.right"))")
                    
                }
                .buttonStyle(GlassProminentButtonStyle())
                .disabled(app.completedDocuments != app.totalDocuments)
                .tint(app.completedDocuments == app.totalDocuments ? NBNColors.bondiBlue : NBNColors.doveGray.opacity(0.5))
                
                
            }
        }
    }
}

#Preview {
    ReserveFlightCard()
}
