//
//  Documents.swift
//  NBN
//
//  Created by RJ  Kigner on 1/2/26.
//
import SwiftUI

struct Documents: View {
    @StateObject private var app = AppModel.shared
    var onSelectDocuments: (() -> Void)? = nil
    
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
            VStack(alignment: .center) {
                HStack(){
                    VStack{
                        Image("Icon06")
                            .renderingMode(.template)
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        Image("Icon05")
                            .renderingMode(.template)
                            .foregroundColor(.black)
                        
                    }
                    Spacer()
                    
                    VStack{
                        Text("\(app.progress?.generalUploaded ?? 0) / \(app.progress?.generalTotal ?? 2)")
                            .font(.headline.weight(.semibold))
                            .foregroundStyle(NBNColors.bondiBlue)
                            .padding(.vertical, 2)
                            .padding(.horizontal, 8)
                            .overlay(
                                Capsule()
                                    .stroke(NBNColors.bondiBlue, lineWidth: 2)
                            )
                        Spacer()
                        
                        Text("\(app.progress?.personalUploaded ?? 0) / \(app.progress?.personalTotal ?? 10)")
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
                    
                    VStack{
                        Text(app.applicantName.isEmpty ? "Raphael Kigner" : app.applicantName)
                        Spacer()
                        Text("General Documents")
                    }
                    
                }
                Button {
                    onSelectDocuments?()
                } label: {
                    Text("See All")
                }
                
                .buttonStyle(GlassProminentButtonStyle())
                .tint(NBNColors.bondiBlue)
            }
        }
    }
}


#Preview {
    let app = AppModel.shared
    let applicant = Applicant(
        id: UUID().uuidString,
        name: "Raphael Kigner",
        email: "kigrj1@gmail.com",
        phone: "+1-212-555-0188",
        dateOfBirth: "2000-10-06",
        advisor: "Ploni Almoni",
        advisorEmail: "PloniAmoni@nbn.org.il",
        profilePicture: nil,
        createdAt: ISO8601DateFormatter().string(from: Date()),
        documents: DocumentName.allCases.map { doc in
            Document(name: doc.rawValue, status: .missing, uploadedAt: nil, fileName: nil, filePath: nil, mimeType: nil, size: nil)
        }
    )
    app.setApplicant(applicant)
    return Documents()
}
