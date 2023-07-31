//
//  User.swift
//  officalmicdrop
//
//  Created by Leo Juarez on 6/4/23.
//

import FirebaseFirestoreSwift
import Firebase

struct User: Identifiable, Decodable {
    @DocumentID var id: String?
    
    let username: String
    let fullname: String
    let profileImageUrl: String
    let email: String
    let hashtags: [String]
    let latitude: Double
    let longitude: Double
    var hashtagProfile: HashtagProfile?  // Add this line  // Add this line
    var lastMessage: HashtagMessage?
    var bio: String? // Add this line

    var isCurrentUser: Bool { return Auth.auth().currentUser?.uid == id}
}



