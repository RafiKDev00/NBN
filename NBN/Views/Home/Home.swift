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
        VStack {
            HomeTextCard(width: .infinity ,height: 200){
                Text("Application Progress")
                    .font(.title2)
                    .fontWeight(.semibold)
            } content: {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Your advisor is: \(app.applicantAdvisor)")
                    Text("hello")
                }
            }
            HStack(spacing: 8) {
                HomeTextCard(width: .infinity ,height: 200){
                    Text("Aliyah Advisor")
                        .font(.title3)
                        .fontWeight(.semibold)
                } content: {
                    VStack(alignment: .center, spacing: 6) {
                        Text("\(app.applicantAdvisor)")
                        HStack(spacing: 0) {
                            Image(systemName: "envelope")
                            Text(" \(app.applicantAdvisorEmail)")
                        }
                        Image(systemName: "lifepreserver")
                            .font(.system(size: 45))
                        
                        Text("Please Share Feedback about the application: ")
                    }
                    .font(.caption)
                }
                
                HomeTextCard(width: .infinity ,height: 200){
                    Text("Reserve Flight")
                        .font(.title3)
                        .fontWeight(.semibold)
                } content: {
                    VStack(alignment: .center, spacing: 0) {
                        Spacer()
                            if 
                        
                        Button {
                            
                        } label:{
                            Text("schedule flight")
                            
                        }
                        .buttonStyle(GlassButtonStyle())
                        
                        Spacer()
                        
                    }
                }
            }
            .padding(.vertical, 8)
            HomeTextCard(width: .infinity ,height: 200){
                Text("Application Progress")
                    .font(.title2)
                    .fontWeight(.semibold)
            } content: {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Your advisor is: \(app.applicantAdvisor)")
                    Text("hello")
                }
            }
            Spacer()
        }
        .padding(.top, 12)
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                    .shadow(color: NBNColors.bondiBlue.opacity(0.3), radius: 4, y: 0)
            )
        }
    }
}

#Preview {
    Home()
}
