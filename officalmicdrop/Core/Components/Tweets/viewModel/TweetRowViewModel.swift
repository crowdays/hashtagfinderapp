//
//  TweetRowViewModel.swift
//  officalmicdrop
//
//  Created by Leo Juarez on 6/13/23.
//

import Foundation
import Firebase

class TweetRowViewModel: ObservableObject {
    
    private let service = DropService()
    let drop: Drop
    var ratingManager: RatingManager
    @Published var rating: Int? // stores the rating given by the user
    @Published var aggregateRatings: [String: Int] = [:]
    @Published var ratings: [String: [String: Int]]?
    private var listener: ListenerRegistration?
    
    var userRating: String? {
        guard let uid = Auth.auth().currentUser?.uid else { return nil }
        return ratings?[uid]?.keys.first
    }
    
    init(drop: Drop, ratingManager: RatingManager) {
        self.drop = drop
        self.ratingManager = ratingManager

        self.listener = Firestore.firestore().collection("drops").document(drop.id ?? "")
            .addSnapshotListener { [weak self] (documentSnapshot, error) in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                self?.ratings = data["ratings"] as? [String: [String: Int]] // Update this line
                self?.computeAggregateRatings()
        }
    }

    deinit {
        listener?.remove()
    }
    
    func rateStar(stars: Int) {
        guard let dropId = drop.id else {
            print("Failed to get drop ID")
            return
        }
        
        service.rateStars(dropId: dropId, stars: stars) { (success) in
            if success {
                print("Successfully rated star")
                self.rating = stars
                // Manually update the userRating here
                self.ratings?[Auth.auth().currentUser?.uid ?? ""] = [String(stars): 1]
                self.computeAggregateRatings()
            } else {
                print("Failed to rate star")
            }
        }
    }

    private func computeAggregateRatings() {
        guard let ratings = self.ratings else { return }
        var aggregates: [String: Int] = ["1": 0, "2": 0, "3": 0, "4": 0, "5": 0]
        
        for userRatings in ratings.values {
            for (star, count) in userRatings {
                aggregates[star, default: 0] += count
            }
        }
        
        self.aggregateRatings = aggregates
        self.objectWillChange.send()  // Manually trigger an update
    }

}



