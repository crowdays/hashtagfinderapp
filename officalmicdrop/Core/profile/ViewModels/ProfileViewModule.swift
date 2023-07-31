//
//  ProfileViewModule.swift
//  officalmicdrop
//
//  Created by Leo Juarez on 6/13/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class ProfileViewModel: ObservableObject {
    @Published var drops = [Drop]()
    @Published var following: [String] = []
    @Published var followers: [String] = []
    let service = DropService()
    let userService = UserService()
    let user: User
    var followersListener: ListenerRegistration?  // Add this line

    init(user: User) {
        self.user = user
        self.fetchUserDrops()
        self.fetchFollowing()
        self.startListeningForFollowers()  // Add this line
    }

    deinit {
        followersListener?.remove()  // Add this line
    }

    
    var actionButtonTitle: String {
        return user.isCurrentUser ? "Edit Profile" : "Follow"
    }
    
    
    func fetchUserDrops() {
        guard let uid = user.id else { return }
        
        service.fetchDrops(foruid: uid) { drops in
            self.drops = drops
            
            for i in 0 ..< drops.count {
                self.drops[i].user = self.user // use "i" here, not "1"
            }
        }
    }
    
    func fetchFollowing() {
        guard let uid = user.id else { return }
        
        Firestore.firestore().collection("users").document(uid).collection("following").getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            
            self.following = documents.map { $0.documentID }
        }
    }

    func fetchFollowers() {
        guard let uid = user.id else { return }
        
        Firestore.firestore().collection("users").document(uid).collection("followers").getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            
            self.followers = documents.map { $0.documentID }
        }
    }

    
    func followUser() {
        guard let currentUserId = Auth.auth().currentUser?.uid,
              let followedUserId = user.id,
              !following.contains(followedUserId) else { return }

        userService.followUser(currentUserId: currentUserId, followedUserId: followedUserId) { error in
            if let error = error {
                print("Failed to follow user: \(error)")
            } else {
                self.following.append(followedUserId)
            }
        }
    }

    func unfollowUser() {
        guard let currentUserId = Auth.auth().currentUser?.uid,
              let followedUserId = user.id,
              following.contains(followedUserId) else { return }

        userService.unfollowUser(currentUserId: currentUserId, followedUserId: followedUserId) { error in
            if let error = error {
                print("Failed to unfollow user: \(error)")
            } else {
                self.following.removeAll(where: { $0 == followedUserId })
            }
        }
    }

    func startListeningForFollowers() {
        guard let uid = user.id else { return }

        followersListener = Firestore.firestore().collection("users").document(uid).collection("followers").addSnapshotListener { snapshot, _ in
            guard let documents = snapshot?.documents else { return }

            self.followers = documents.map { $0.documentID }
        }
    }
    
  }
    

