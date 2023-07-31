//
//  UserService.swift
//  officalmicdrop
//
//  Created by Leo Juarez on 6/4/23.
//

import Firebase
import FirebaseFirestoreSwift

struct UserService {
    
    func fetchUser(withUid uid: String, completion: @escaping(User) -> Void) {
        Firestore.firestore().collection("users")
            .document(uid)
            .getDocument { snapshot, _ in
                guard let snapshot = snapshot  else { return }
                
                guard let user = try? snapshot.data(as: User.self) else { return }
                
                completion(user)
                
                
            }
        
    }
    func fetchUsers(completion: @escaping([User]) -> Void) {
        Firestore.firestore().collection("users").getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            
            let users = documents.compactMap({ try? $0.data(as: User.self) })
            completion(users)
        }
    }

    
    func followUser(currentUserId: String, followedUserId: String, completion: @escaping (Error?) -> Void) {
        let followingRef = Firestore.firestore().collection("users").document(currentUserId).collection("following").document(followedUserId)
        let followersRef = Firestore.firestore().collection("users").document(followedUserId).collection("followers").document(currentUserId)
        
        let batch = Firestore.firestore().batch()
        batch.setData([:], forDocument: followingRef)
        batch.setData([:], forDocument: followersRef)
        
        batch.commit(completion: completion)
    }

    func unfollowUser(currentUserId: String, followedUserId: String, completion: @escaping (Error?) -> Void) {
        let followingRef = Firestore.firestore().collection("users").document(currentUserId).collection("following").document(followedUserId)
        let followersRef = Firestore.firestore().collection("users").document(followedUserId).collection("followers").document(currentUserId)
        
        let batch = Firestore.firestore().batch()
        batch.deleteDocument(followingRef)
        batch.deleteDocument(followersRef)
        
        batch.commit(completion: completion)
    }

    
    func saveEmblem(emblem: Emblem, completion: @escaping (Error?) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        do {
            let _ = try Firestore.firestore().collection("users").document(userID).collection("emblems").addDocument(from: emblem, completion: { error in
                completion(error)
            })
        } catch let error {
            completion(error)
        }
    }
    
    func loadEmblems(completion: @escaping ([Emblem]) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("users").document(userID).collection("emblems").getDocuments { snapshot, error in
            if let error = error {
                print("Error loading emblems: \(error)")
                completion([])
            } else if let snapshot = snapshot {
                let emblems = snapshot.documents.compactMap { try? $0.data(as: Emblem.self) }
                completion(emblems)
            }
        }
    }

    
}

    
    
    
    
    
    

