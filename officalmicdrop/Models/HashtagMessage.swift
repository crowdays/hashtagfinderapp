//
//  HashtagMessage.swift
//  officalmicdrop
//
//  Created by Leo Juarez on 6/22/23.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase

struct HashtagMessage: Identifiable, Codable {
    @DocumentID var id: String?
    let senderId: String
    let senderUsername: String
    let content: String
    let timestamp: Timestamp
    var imageURL: String?
    var audioURL: String?

    // You can also include a dictionary property for Firestore
    var dictionary: [String: Any] {
        return [
            "senderId": senderId,
            "content": content,
            "timestamp": timestamp,
            "imageURL": imageURL as Any,
            "audioURL": audioURL as Any
        ]
    }
}

