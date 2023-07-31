//
//  EditProfileView.swift
//  officalmicdrop
//
//  Created by Leo Juarez on 7/23/23.
//

import Firebase
import FirebaseFirestore


import SwiftUI

struct EditProfileView: View {
    @State var user: User
    @State var bio: String
    @Environment(\.presentationMode) var presentationMode
    
    
    init(user: User) {
        self._user = State(initialValue: user)
        self._bio = State(initialValue: user.bio ?? "")
    }
    
    var body: some View {
        Form {
            Section(header: Text("Profile Picture")) {
                // Add code to change profile picture
            }
            
            Section(header: Text("Header Picture")) {
                // Add code to change header picture
            }
            
            Section(header: Text("Voice Message")) {
                // Add code to change voice message
            }
            
            TextField("Bio", text: $bio)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.horizontal)
        }
        Button(action: {
            // Save the changes
            user.bio = bio
            // Save the changes to Firestore
            let db = Firestore.firestore()
            db.collection("users").document(user.id ?? "").updateData([
                "bio": bio
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                    // Dismiss the view
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }) {
            Text("Save")
        }
    }
}

