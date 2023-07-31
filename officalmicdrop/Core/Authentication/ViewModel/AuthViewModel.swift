//
//  AuthViewModel.swift
//  officalmicdrop
//
//  Created by Leo Juarez on 6/3/23.
//

import SwiftUI
import Firebase
import CoreLocation

class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var didAuthenticateUser = false
    @Published var currentUser: User?
    private var tempUserSession: FirebaseAuth.User?
    @Published var users: [User] = []
    @Published var selectedHashtags: [String] = []
    private let service = UserService()
    
    init() {
        self.userSession = Auth.auth().currentUser
        self.fetchUser()
    }
    
    func login(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: failed to sign in with error \(error.localizedDescription)")
            }
            guard let user = result?.user else { return }
            self.userSession = user
            self.fetchUser()
        }
    }
    
    func register(withEmail email: String, password: String, fullname: String, username: String) {
        LocationService.shared.startUpdatingLocation()

        LocationService.shared.onLocationUpdate = { location in
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let error = error {
                    print("DEBUG Failed to register with error \(error.localizedDescription)")
                    return
                }
                guard let user = result?.user else { return }
                self.tempUserSession = user
                
                // Create a new hashtag profile
                let hashtagProfileData = [
                    "bio": "",
                    "voiceMessageUrl": "",
                    "image1Url": "",
                    "image2Url": ""
                ] as [String : Any]
                let hashtagProfileDocument = Firestore.firestore().collection("hashtagProfiles").document(user.uid)
                hashtagProfileDocument.setData(hashtagProfileData)
                
                // Create a new user
                let userData = [
                    "email" : email,
                    "username": username.lowercased(),
                    "fullname": fullname,
                    "uid": user.uid,
                    "latitude": location.coordinate.latitude,
                    "longitude": location.coordinate.longitude,
                    "hashtagProfileId": hashtagProfileDocument.documentID
                ] as [String : Any]
                
                Firestore.firestore().collection("users")
                    .document(user.uid)
                    .setData(userData) { _ in
                        self.didAuthenticateUser = true
                    }
            }
        }
    }

    
    func signOut() {
        userSession = nil
        try? Auth.auth().signOut()
    }
    
    func uploadProfileImage(_ image: UIImage, hashtags: [String]) {
        guard let uid = tempUserSession?.uid else { return }

        ImageUploader.uploadImage(image: image) { profileImageUrl in
            Firestore.firestore().collection("users")
                .document(uid)
                .updateData([
                    "profileImageUrl": profileImageUrl,
                    "hashtags": hashtags
                ]) { _ in
                    self.userSession = self.tempUserSession
                    self.fetchUser()
                }
        }
    }
    
    func fetchUser() {
        guard let uid = self.userSession?.uid else { return }
        
        service.fetchUser(withUid: uid) { user in
            self.currentUser = user

            // Fetch the user's HashtagProfile here
            Firestore.firestore().collection("hashtagProfiles").document(uid).getDocument { (snapshot, error) in
                if let error = error {
                    print("Error fetching user's HashtagProfile: \(error)")
                } else if let data = snapshot?.data() {
                    let hashtagProfile = HashtagProfile(dictionary: data)
                    self.currentUser?.hashtagProfile = hashtagProfile
                }
            }
        }
    }


}
