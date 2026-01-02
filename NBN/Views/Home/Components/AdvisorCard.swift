//
//  AdvisorCard.swift
//  NBN
//
//  Created by RJ  Kigner on 1/2/26.
//

import SwiftUI

struct AdvisorCard: View{
    @StateObject private var app = AppModel.shared
    
    var body: some View{
        HomeTextCard(height: 200){
            Text("Aliyah Advisor")
                .font(.title3)
                .fontWeight(.semibold)
        } content: {
        VStack(alignment: .center, spacing: 6) {
            Text("\(app.applicantAdvisor)")
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
            HStack(alignment: .top, spacing: 4) {
                Image(systemName: "envelope")
                Text("\(app.applicantAdvisorEmail)")
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Image(systemName: "lifepreserver")
                .font(.system(size: 40, weight: .thin))
            
            Text("Please Share Feedback about the application: ")
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
            Link("Tap Here", destination: URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSda9dYuXKxZZl3ubPsiqazFrQMFsFi6pH7UQ023E3BQBE3k8A/viewform")!)
        }
        .font(.caption)
        .frame(maxWidth: .infinity, alignment: .center)
    }
        
    }
}

#Preview {
    AdvisorCard()
}
