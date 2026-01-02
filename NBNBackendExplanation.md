# NBN Backend & Client Wiring

## Backend Overview
- **Stack**: Node/Express, SQLite (via sql.js), Multer for file uploads.
- **Storage**:
  - DB file: `db/nbn.sqlite` (auto-created/migrated on start).
  - Uploads: `uploads/<applicantId>/` (files on disk; metadata in DB).
- **Tables**:
  - `applicants`: `id`, `name`, `email`, `phone`, `dateOfBirth`, `advisor`, `advisorEmail`, `profilePicture`, `createdAt`, `authToken`.
  - `documents`: one row per applicant/document. Fields: `name`, `status` (`missing`/`received`), `uploadedAt`, `fileName`, `filePath`, `mimeType`, `size`.
  - `auth_codes`: transient login codes (`email`, `code`, `createdAt`).
- **Required docs (12)**: Passport, Aliyah Visa, Birth Certificate, Proof Of Judaism, Health Declaration, Apostille On Birth Certificate, Passport Photos, Entry And Exit Form, Criminal Background Check, Apostille On Criminal Background Check, Waiver Of Confidentiality, Photograph Of Family Member(s) Making Aliyah. Seeded as `missing` per new applicant.
- **General vs Personal**: General docs = Waiver Of Confidentiality + Photograph Of Family Member(s) Making Aliyah. Personal docs = the other 10.

## Endpoints (server.js)
- **Auth**:
  - `POST /auth/request-code` { email, name?, phone?, dateOfBirth?, advisor?, advisorEmail? }: creates applicant if missing, stores 6-digit code (also returned in response for dev).
  - `POST /auth/verify` { email, code }: validates code (15 min), sets `authToken`, returns `{ token, applicant }`.
- **Applicants**:
  - `GET /applicants`
  - `GET /applicants/:id`
  - `GET /applicants/by-email/:email`
  - `POST /applicants`: defaults advisor to “Ploni Almoni” and advisorEmail to `PloniAmoni@nbn.org.il`; seeds all docs missing.
  - `PATCH /applicants/:id`: updates basic fields + advisor/advisorEmail.
- **Documents**:
  - `POST /applicants/:id/documents/:name/upload` (multipart `file`): saves to `uploads/<id>/`, marks doc `received`, records metadata.
- **Status**:
  - `GET /applicants/:id/documents/complete`: `{ complete: Bool }` (all docs received).
  - `GET /applicants/:id/documents/progress`: 
    - `uploaded`, `remaining`, `total`
    - `generalUploaded`, `generalRemaining`, `generalTotal`
    - `personalUploaded`, `personalRemaining`, `personalTotal`

## Running Locally
- Install deps: `npm install`
- Start: `HOST=127.0.0.1 PORT=3000 npm start` (or 3001; adjust client baseURL).
- Persistence: DB in `db/nbn.sqlite`; uploads in `uploads/`.

## Client Wiring (Swift/SwiftUI)
- **Networking**: `NBNAPI` (URLSession). Base URL currently `http://127.0.0.1:3001` in code; change to 3000 if needed. Adds Bearer from Keychain.
- **Keychain**: `Keychain.bearerToken` set on login verify.
- **Models**: `Applicant` (advisor, advisorEmail), `Document`, `CreateApplicantRequest`, `UpdateApplicantRequest`, `ProgressResponse` (general/personal counts).
- **Shared state**: `AppModel.shared` holds `applicant`, `progress`; helpers for counts and applicant fields; API-backed setters (`updateApplicantRemote`, `uploadDocumentRemote`); session helpers (`setApplicant`, `refreshApplicant`, `loadProgress`, `signOut`).

## Auth Flow
1) Request code → `NBNAPI.requestLoginCode(...)` (creates applicant if missing).
2) Verify code → `NBNAPI.verifyLoginCode(...)` → returns `token` + `applicant`.
3) Client sets `Keychain.bearerToken` + `AppModel.setApplicant`.

## Upload Flow
- Call `AppModel.uploadDocumentRemote(doc: DocumentName, fileURL: URL)` → backend marks received, stores metadata → local model updated.

## Progress Usage
- `await AppModel.loadProgress()` populates `progress` (general/personal included).
- Derived counts: `completedDocuments`, `totalDocuments`, `remainingDocuments`; or use `ProgressResponse` fields directly.

## Tabs
- `ContentView` TabView (default selection = Home). Home gets closures to jump to Flight/Documents tabs; Reserve Flight button uses completion to enable/tint and calls `onSelectFlight` when ready.

## Previews
- Some components seed `AppModel` with mock applicants; adjust seed data to see 0/12 vs 12/12.
