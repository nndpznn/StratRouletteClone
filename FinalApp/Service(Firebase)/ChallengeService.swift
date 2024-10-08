//
//  ChallengeService.swift
//  FinalApp
//
//  Created by Nolan Nguyen on 4/17/24.
//

import Foundation

import Firebase

let CHALLENGE_COLLECTION_NAME = "challenges"
let PAGE_LIMIT = 20

enum ChallengeServiceError: Error {
    case mismatchedDocumentError
    case unexpectedError
}

// DILEMMA: Do we use .document(id).setData, so we can fetch challenges by ID like we wanted to?
// Or, do we just use .addDocument? Can we still fetch these?
class ChallengeService: ObservableObject {
    private let db = Firestore.firestore()
    
    @Published var error: Error?
    
    func createChallenge(challenge: Challenge) -> Void {
//        var ref: DocumentReference? = nil
        
        db.collection(CHALLENGE_COLLECTION_NAME).addDocument(data: [
            "id": challenge.id,
            "title": challenge.title,
            "description": challenge.description,
            "authorID": challenge.authorID
        ]) { possibleError in
            if let actualError = possibleError {
                self.error = actualError
            }
        }
        
        return
    }
    
    func fetchChallenges() async throws -> [Challenge] {
        let challengeQuery = db.collection(CHALLENGE_COLLECTION_NAME)
            .limit(to: PAGE_LIMIT)
        
        do {
            let querySnapshot = try await challengeQuery.getDocuments()
            
            return try querySnapshot.documents.map {
                
                guard let title = $0.get("title") as? String,
                      let description = $0.get("description") as? String,
                      let authorID = $0.get("authorID") as? String
                else {
                    throw ChallengeServiceError.mismatchedDocumentError
                }
                
                return Challenge(
                    id: $0.documentID,
                    title: title,
                    description: description,
                    authorID: authorID
                )
            }
        } catch {
            print("error fetching posts: \(error)")
            throw error
        }
    }
    
//    func fetchChallenge(uid: String) async throws -> Challenge {
//        let challengeQuery = db.collection(COLLECTION_NAME)
//        
//        let querySnapshot = try await challengeQuery.document(uid).getDocument()
//          
//        return querySnapshot.data().map { _ in
//            let id = querySnapshot.get("id") as? String ?? "No ID"
//            
//            let title = querySnapshot.get("title") as? String ?? "Not Found"
//            
//            let description = querySnapshot.get("description") as? String ?? ""
//            
//            let author = querySnapshot.get("author") as! Author
//            
//            return Challenge(id:id, title:title, description:description, author:author)
//        }!
//    }
}
