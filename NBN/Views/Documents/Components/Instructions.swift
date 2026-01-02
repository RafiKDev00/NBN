//
//  Instructions.swift
//  NBN
//
//  Created by RJ  Kigner on 1/2/26.
//

import SwiftUI

struct Instructions: View {
    @State private var isExpanded = false
    
    var body: some View {
        HomeTextCard(width: .infinity, height: isExpanded ? nil : 80) {
            HStack(spacing: 10) {
                Image(systemName: "info.circle")
                    .foregroundStyle(NBNColors.elAlHaiti)
                Text("Instructions")
                    .font(.title3.weight(.semibold))
                Spacer()
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundStyle(NBNColors.doveGray)
            }
        } content: {
            if isExpanded {
                VStack(alignment: .leading, spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Files")
                            .font(.headline)
                        Text("Please upload your documents below – the size of the document cannot exceed 15mb.")
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Languages")
                            .font(.headline)
                        Text("Documents must be in English, French, Russian, or Hebrew; otherwise upload the original plus a notarized translation in English or Hebrew.")
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Authentication")
                            .font(.headline)
                        Text("International civil documents require authentication (Apostille or consular stamp).")
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Need help?")
                            .font(.headline)
                        Text("If you are experiencing difficulties please email appsupport@nbn.org.il or contact your Aliyah Advisor for assistance.")
                    }
                }
            }
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.25)) {
                isExpanded.toggle()
            }
        }
    }
}

#Preview {
    Instructions()
}
