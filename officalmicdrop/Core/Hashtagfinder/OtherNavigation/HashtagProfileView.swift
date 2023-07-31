//  HashtagProfileView.swift
//  officalmicdrop
//
//  Created by Leo Juarez on 6/13/23.
//

import SwiftUI
import Kingfisher
import Firebase

struct HashtagProfileView: View {
    @State private var profile: HashtagProfile?
    @State private var showingEditView = false


    var body: some View {
        VStack {
            ZStack {
                
                Text(profile?.userId ?? "Name")
                    .foregroundColor(.white)
                    .rotationEffect(.degrees(-90))
                    .font(.title)
            }
        
            
            Button(action: {
                showingEditView = true
            }) {
                Text("Edit Profile")
            }
            .foregroundColor(Color(red: 1.00, green: 0.84, blue: 0.00))
            
            .sheet(isPresented: $showingEditView) {
                       EditHashtagProfileView(viewModel: EditProfileViewModel(hashtagProfile: profile))
                   }

            .frame(height: 20)
            
            Text(profile?.bio ?? "Bio")
                .font(.body)
            
            
            // Add player view if voice message URL is available
            if let profile = profile {
                if let voiceMessageUrl = profile.voiceMessageUrl, let audioURL = URL(string: voiceMessageUrl) {
                    PlayerView(audioURL: audioURL)
                } else {
                    Text("No Audio URL")
                }
            } else {
                Text("No Profile")
            }
            Spacer()
                .frame(height: 20)
            
            // Replace the circles with images if available
            if let image1Url = profile?.image1Url, let url = URL(string: image1Url) {
                KFImage(url)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
            } else {
                ZStack {
                    Circle()
                        .foregroundColor(.black)
                        .frame(width: 250, height: 250)
                }
            }
            
            if let image2Url = profile?.image2Url, let url = URL(string: image2Url) {
                KFImage(url)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
            } else {
                ZStack {
                    Circle()
                        .foregroundColor(.black)
                        .frame(width: 250, height: 250)
                }
            }

          
        
        }
        Spacer()
        .onAppear {
            fetchProfile()
        }
    }
    


    
    
    private func fetchProfile() {
            guard let userId = Auth.auth().currentUser?.uid else { return }
            
            HashtagProfileService.shared.fetchHashtagProfile(userId: userId) { profile in
                self.profile = profile
            }
        }
}
