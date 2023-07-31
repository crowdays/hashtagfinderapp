//
//  Drop.swift
//  officalmicdrop
//
//  Created by Leo Juarez on 6/10/23.
//

import FirebaseFirestoreSwift
import Firebase

struct Drop: Identifiable, Decodable {
    @DocumentID var id: String?
    let caption: String
    let timestamp: Timestamp
    let uid: String
    var Stars: Int
    let audioURL: String?
    var user: User?
    var ratings: [String: [String: Int]]?  // New field
    var imageURLs: [String]?

    // Computed property to calculate the total count of all ratings
    var totalRatingsCount: Int {
        // Sum up all the counts in the ratings dictionary
        return ratings?.values.reduce(0, { $0 + $1.values.reduce(0, +) }) ?? 0
    }
}
