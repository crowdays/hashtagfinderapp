//  EditProfileViewModel.swift
//  officalmicdrop
//
//  Created by Leo Juarez on 6/17/23.
//

import Foundation
import UIKit
import Firebase
import AVFoundation

class EditProfileViewModel: ObservableObject {
    @Published var didSaveChanges = false
    @Published var user: User? // user is now optional and will be nil initially
    @Published var images: [UIImage] = [] // new property to hold the images
    @Published var hashtagProfile: HashtagProfile?
    @Published var audioData: Data? // new property to hold the audio data
    let service = HashtagProfileService.shared

    init(hashtagProfile: HashtagProfile? = nil) {
        self.hashtagProfile = hashtagProfile
        fetchCurrentUser()
    }

    func saveProfileChanges(profile: HashtagProfile, images: [UIImage], audioData: Data?) {
        service.updateHashtagProfile(profile: profile, images: images, audioData: audioData) { success in
            if success {
                self.didSaveChanges = true
                // Also update the profile and images properties here
                self.hashtagProfile = profile
                self.images = images
                // Update the audio data property if needed
                self.audioData = audioData
            } else {
                print("Error saving profile changes")
            }
        }
    }

    private func fetchCurrentUser() {
        guard let uid = Auth.auth().currentUser?.uid else {
            // Handle case where there is no current user
            return
        }

        UserService().fetchUser(withUid: uid) { user in
            self.user = user
        }
    }

    private func fetchCurrentProfile() {
        guard let uid = Auth.auth().currentUser?.uid else {
            // Handle case where there is no current user
            return
        }

        service.fetchHashtagProfile(userId: uid) { profile in
            self.hashtagProfile = profile
            // Here, you need to download the images from the profile's image URLs and assign them to the images property
            // Use a library like Kingfisher or SDWebImage to download the images
            // Also download and assign the audio data if needed
        }
    }
    
    func fetchUserProfile(userId: String) {
        service.fetchHashtagProfile(userId: userId) { profile in
            self.hashtagProfile = profile
        }
    }
}

