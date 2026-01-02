//
//  Instructions.swift
//  NBN
//
//  Created by RJ  Kigner on 1/2/26.
//

import SwiftUI

struct Instructions: View {
    var body: some View {
        HomeTextCard(width: .infinity, height: 160) {
            Text("Language Instructions")
                .font(.headline)
        } content: {
            VStack(alignment: .leading){
                Text("Languages")
                    .font(.system(size: 20, weight: .semibold))
                Text("Documents must be English, French, Russian or Hebrew, otherwise you must submit the original and notarized translation in English or Hebrew")
            }
            
        }
        
        HomeTextCard(width: .infinity, height: 160) {
            Text("Authentication Instructions")
                .font(.headline)
        } content: {
            VStack(alignment: .leading){
                Text("Authentication")
                    .font(.system(size: 20, weight: .semibold))
                Text("You will be required to provide authentication for International civil documents (Apostille or consular stamp).")
            }
            
        }
    }
}

#Preview {
    Instructions()
}
