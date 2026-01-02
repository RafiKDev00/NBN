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
                HStack(spacing: 6) {
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
            }
        } content: {
            HStack(){
                VStack(){
                    Image("Icon06")
                        .renderingMode(.template)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Image("Icon05")
                        .renderingMode(.template)
                        .foregroundColor(.black)
                    
                }
                Spacer()
                
                VStack(){
                    Text("\(app.completedDocuments) / 2")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(NBNColors.bondiBlue)
                        .padding(.vertical, 2)
                        .padding(.horizontal, 8)
                        .overlay(
                            Capsule()
                                .stroke(NBNColors.bondiBlue, lineWidth: 2)
                        )
                    Spacer()
                    
                    Text("\(app.completedDocuments) / 10")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(NBNColors.bondiBlue)
                        .padding(.vertical, 2)
                        .padding(.horizontal, 8)
                        .overlay(
                            Capsule()
                                .stroke(NBNColors.bondiBlue, lineWidth: 2)
                        )
                    
                }
                
                Spacer()
                
                VStack(){
                    Text(app.applicantName)
                    Spacer()
                    Text("General Documents")
                }
            }
        }
    }
}


#Preview {
    Documents()
}
