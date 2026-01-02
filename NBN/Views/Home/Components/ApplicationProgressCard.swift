//
//  ApplicationProgressCard.swift
//  NBN
//
//  Created by RJ  Kigner on 1/2/26.
//

import SwiftUI

struct ApplicationProgressCard: View{
    @StateObject private var app = AppModel.shared
    @State private var submitted: Bool
    var overrideCompleted: Int?
    var overrideTotal: Int?
    
    private var completedDocs: Int {
        overrideCompleted ?? app.completedDocuments
    }
    
    private var totalDocs: Int {
        overrideTotal ?? app.totalDocuments
    }
    
    private var isComplete: Bool {
        let total = totalDocs
        return total > 0 && completedDocs >= total
    }
    
    private var statusText: String {
        if submitted {
            return "Submitted, contact your advisor to request information, updates, or changes."
        } else if isComplete {
            return "All completed! Click Submit below to complete the process!"
        } else {
            return "Complete all documents to submit your application"
        }
    }
    
    init(initialSubmitted: Bool = false, overrideCompleted: Int? = nil, overrideTotal: Int? = nil) {
        _submitted = State(initialValue: initialSubmitted)
        self.overrideCompleted = overrideCompleted
        self.overrideTotal = overrideTotal
    }
    
    var body: some View {
        HomeTextCard(height: 200){
            Text("Application Progress")
                .font(.title2)
                .fontWeight(.semibold)
        } content: {
            HStack(alignment: .top, spacing: 8) {
                VStack(alignment: .center) {
                    Text(statusText)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                    Button{
                        guard isComplete else { return }
                        submitted = true
                    }label: {
                        Text("Submit")
                            .foregroundStyle(isComplete ? NBNColors.alabaster : NBNColors.doveGray)
                    }
                    .buttonStyle(GlassProminentButtonStyle())
                    .disabled(!isComplete || submitted)
                    .background(
                        (isComplete ? NBNColors.elAlHaiti : NBNColors.doveGray.opacity(0.2))
                            .clipShape(Capsule())
                    )
                    
                    
                }
                
                Spacer()
                ProgressRing(overrideCompleted: overrideCompleted, overrideTotal: overrideTotal)
            }
            .padding(8)
        }
    }
}

private func makePreviewApplicant(completed: Int) -> Applicant {
    let docs = DocumentName.allCases.enumerated().map { idx, name in
        Document(
            name: name.rawValue,
            status: idx < completed ? .received : .missing,
            uploadedAt: nil,
            fileName: nil,
            filePath: nil,
            mimeType: nil,
            size: nil
        )
    }
    
    return Applicant(
        id: UUID().uuidString,
        name: "Preview User",
        email: "preview@example.com",
        phone: "+1-555-000-0000",
        dateOfBirth: "1990-01-01",
        advisor: "Ploni Almoni",
        advisorEmail: "PloniAmoni@nbn.org.il",
        profilePicture: nil,
        createdAt: Date().iso8601String(),
        documents: docs
    )
}

private extension Date {
    func iso8601String() -> String {
        ISO8601DateFormatter().string(from: self)
    }
}

#Preview {
    let app = AppModel.shared
    return Group {
        ApplicationProgressCardPreview(completed: 6, submitted: false)
            .previewDisplayName("Incomplete")
        ApplicationProgressCardPreview(completed: 12, submitted: false)
            .previewDisplayName("Complete, not submitted")
        ApplicationProgressCardPreview(completed: 12, submitted: true)
            .previewDisplayName("Submitted")
    }
}

private struct ApplicationProgressCardPreview: View {
    let completed: Int
    let submitted: Bool
    
    var body: some View {
        ApplicationProgressCard(initialSubmitted: submitted, overrideCompleted: completed, overrideTotal: 12)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}
