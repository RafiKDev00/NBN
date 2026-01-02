//
//  ApplicationProgressCard.swift
//  NBN
//
//  Created by RJ  Kigner on 1/2/26.
//

import SwiftUI

struct ApplicationProgressCard: View{
    @StateObject private var app = AppModel.shared
    
    var body: some View {
        HomeTextCard(height: 200){
            Text("Application Progress")
                .font(.title2)
                .fontWeight(.semibold)
        } content: {
            HStack(alignment: .top, spacing: 8) {
                VStack(alignment: .center) {
                    Text("Complete all documents to submit your application")
                    
                    Button {
                        //TODO: submit
                        
                               
  
                    
                    }label:{
                        Text("Submit Application")
                        
                    }
                    buttonStyle(.glass)
                    
                }
                
                Spacer()
                ProgressRing()
            }
            .padding(8)
        }
       
    }
}

#Preview {
    ApplicationProgressCard()
}
