//
//  Documents.swift
//  NBN
//
//  Created by RJ  Kigner on 1/2/26.
//
import SwiftUI

struct Documents: View {
    @StateObject private var app = AppModel.shared
    
    var body: some View {
    
        HomeTextCard(height: 200){
            HStack {
                Text("Documents")
                    .font(.title3.weight(.semibold))
                
                Spacer()
                
                Text("\(app.completedDocuments) / \(app.totalDocuments)")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(NBNColors.bondiBlue)
                    .padding(.vertical, 2)
                    .padding(.horizontal, 8)
                    .overlay(
                        Capsule()
                            .stroke(NBNColors.bondiBlue, lineWidth: 2)
                    )
            }
        } content: {
            VStack(alignment: .leading, spacing: 6) {
                Text("Your advisor is: \(app.applicantAdvisor)")
                Text("hello")
            }
        }
        
    }
}


#Preview {
    Documents()
}
