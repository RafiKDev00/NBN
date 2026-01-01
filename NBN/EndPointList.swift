//
//  EndPointList.swift
//  NBN
//
//  Created by RJ  Kigner on 1/1/26.
//

 /*
- applicantName / applicantEmail / applicantPhone / applicantDOB: current applicant fields.
    - let name = AppModel.shared.applicantName
- document(named: String) / documentStatus(named:): get a document or its status by string name.
    - let passport = AppModel.shared.document(named: "Passport")
- document(_ doc: DocumentName) / documentStatus(_:): same, but type-safe.
    - let status = AppModel.shared.documentStatus(.passport)
- completedDocuments / totalDocuments / remainingDocuments: derived counts.
    - let done = AppModel.shared.completedDocuments
- updateApplicant(name:email:phone:dateOfBirth:profilePicture:): local in-memory update.
    - AppModel.shared.updateApplicant(name: "New Name")
- setDocumentStatus(name:status:uploadedAt:fileName:filePath:mimeType:size:): local doc update.
    - AppModel.shared.setDocumentStatus(name: "Passport", status: .received)
- updateApplicantRemote(_ request: UpdateApplicantRequest) async throws: PATCH backend, update local model.
    - try await AppModel.shared.updateApplicantRemote(UpdateApplicantRequest(name: "New Name"))
- uploadDocumentRemote(_ doc: DocumentName, fileURL: URL) async throws -> Document: upload file, update local model.
    - let doc = try await AppModel.shared.uploadDocumentRemote(.passport, fileURL: fileURL)
- setApplicant(_:): set current applicant and persist id.
    - AppModel.shared.setApplicant(applicant)
- signOut(): clear applicant, token, persisted id.
    - AppModel.shared.signOut()
- refreshApplicant() async: fetch applicant from backend using stored id.
    - await AppModel.shared.refreshApplicant()
- loadProgress() async: fetch progress from backend and store in progress.
    - await AppModel.shared.loadProgress()

DocumentName enum (use instead of raw strings to avoid typos)

- .passport, .aliyahVisa, .birthCertificate, .proofOfJudaism, .healthDeclaration, .apostilleOnBirthCertificate, .passp
  ortPhotos, .entryAndExitForm, .criminalBackgroundCheck, .apostilleOnCriminalBackgroundCheck, .waiverOfConfidentialit
  y, .photographOfFamilyMembersMakingAliyah.

Direct NBNAPI (if you need raw calls)

- listApplicants(): let all = try await NBNAPI().listApplicants()
- getApplicant(id:): let a = try await NBNAPI().getApplicant(id: "…")
- getApplicantByEmail(_:): let a = try await NBNAPI().getApplicantByEmail("kigrj1@gmail.com")
- createApplicant(_:): let a = try await NBNAPI().createApplicant(CreateApplicantRequest(...))
- updateApplicant(id:_:): let a = try await NBNAPI().updateApplicant(id: "…", UpdateApplicantRequest(...))
- uploadDocument(applicantId:documentName:fileURL:): let d = try await NBNAPI().uploadDocument(applicantId: "…",
  documentName: "Passport", fileURL: url)
- documentsComplete(applicantId:): let c = try await NBNAPI().documentsComplete(applicantId: "…")
- documentsProgress(applicantId:): let p = try await NBNAPI().documentsProgress(applicantId: "…")
- Auth: requestLoginCode(...) / verifyLoginCode(...): let code = try await NBNAPI().requestLoginCode(email: "…"); let
  verified = try await NBNAPI().verifyLoginCode(email: "…", code: "123456").

  
  Use like
  
  @StateObject private var app = AppModel.shared

  var body: some View {
      VStack {
          Text("Hello, \(app.applicantName)")
          Text("Completed: \(app.completedDocuments) / \(app.totalDocuments)")

          Button("Refresh progress") {
              Task { await app.loadProgress() }
          }

          Button("Upload Passport") {
              Task {
                  guard let fileURL = /* pick file */ Optional<URL>() else { return }
                  try await app.uploadDocumentRemote(.passport, fileURL: fileURL)
              }
          }
      }
  }

*/
