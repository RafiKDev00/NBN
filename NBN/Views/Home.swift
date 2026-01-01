//
//  Home.swift
//  NBN
//
//  Created by RJ  Kigner on 12/31/25.
//

import SwiftUI

struct Home: View {
    
    @StateObject private var app = AppModel.shared
    
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Welcome, \(app.applicantName)")
                .font(.title2)
                .fontWeight(.semibold)
            Text("hello")
        }
    }
}

#Preview {
    Home()
}
