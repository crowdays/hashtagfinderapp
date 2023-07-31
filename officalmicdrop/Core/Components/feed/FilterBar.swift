//
//  FilterBar.swift
//  officalmicdrop
//
//  Created by Leo Juarez on 6/11/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import CoreLocation




struct FilterBarView: View {
    @AppStorage("miles") private var miles: Double = 10
    @State private var inputText: String = ""
    @State private var circleOffset: CGFloat = 0
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var reselectedTag: String?
    

    @ObservedObject var hashtagViewModel = HashtagDetailViewModel(authViewModel: AuthViewModel())
    @ObservedObject private var locationService = LocationService.shared

    let allTags: [String] = ["Piano", "Guitar", "Drums", "Violin", "Tattoo artist", "Planter", "Male", "Plumber", "Driver" , "Female", "Nail", "Hair Braider"]
    
    var body: some View {
        VStack {
            Divider()
            Text("Set Your Mile Radius ")
                .bold()
            Spacer()
            
            GeometryReader { geometry in
                VStack {
                    Text("\(Int(miles)) miles")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 16)
                    
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .foregroundColor(.gray)
                            .frame(height: 2)
                        
                        Circle()
                            .foregroundColor(.yellow)
                            .frame(width: 16, height: 16)
                            .offset(x: circleOffset)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        updateMiles(value: value, geometry: geometry)
                                    }
                                    .onEnded { value in
                                        updateMiles(value: value, geometry: geometry)
                                    }
                            )
                    }
                }
                .padding()
            }
            
            TextField("Search hashtags to filter users (Max 5)", text: $inputText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .padding(.top, -115)

            Text("Hashtags")
                .font(.headline)
                .foregroundColor(.black)
                .padding(.top)
Divider()
                
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(authViewModel.selectedHashtags, id: \.self) { tag in
                        HStack {
                            Text(tag)
                                .padding()
                                .background(reselectedTag == tag ? Color.black : Color(red: 1.00, green: 0.84, blue: 0.00))
                                .foregroundColor(.white)
                                .cornerRadius(15)
                                .onTapGesture {
                                    
                                    reselectedTag = tag
                                }
                            
                            if reselectedTag == tag {
                                Button(action: {
                                    authViewModel.selectedHashtags.removeAll(where: { $0 == tag })
                                    reselectedTag = nil
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                }
            }
            .padding(.bottom)

            ScrollView {
                VStack {
                    ForEach(allTags.filter { $0.hasPrefix(inputText) && !inputText.isEmpty }, id: \.self) { tag in
                        if !authViewModel.selectedHashtags.contains(tag) {
                            Button(action: {
                                if authViewModel.selectedHashtags.count < 5 {
                                    authViewModel.selectedHashtags.append(tag)
                                }
                            }) {
                                Text(tag)
                                    .foregroundColor(authViewModel.selectedHashtags.contains(tag) ? .blue : .black)
                                    .background(authViewModel.selectedHashtags.contains(tag) ? Color.yellow.opacity(0.2) : Color.clear)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
            }

            
            Spacer()
        }
        .onAppear {
            miles = UserDefaults.standard.double(forKey: "miles")
            updateCircleOffset(geometry: UIScreen.main.bounds.width - 32)
        }
        .onDisappear {
            UserDefaults.standard.set(miles, forKey: "miles")
        }
    }
    
    private func updateCircleOffset(geometry: CGFloat) {
        let totalWidth = geometry
        let percentage = miles / 65.0
        circleOffset = totalWidth * CGFloat(percentage)
    }
    
    private func updateMiles(value: DragGesture.Value, geometry: GeometryProxy) {
        let totalWidth = geometry.size.width - 32
        let offset = max(min(value.location.x, totalWidth), 0)
        let percentage = offset / totalWidth
        miles = min(Double(percentage) * 65.0, 65.0)

        // Set the radius in HashtagDetailViewModel here
        hashtagViewModel.radius = miles

        // Update circleOffset here
        circleOffset = offset
    }




    
    private func saveSelectedHashtags() {
        // Get reference to Firebase Firestore
        let db = Firestore.firestore()
        
        // Save the selected hashtags to the user's document in Firestore
        if let uid = Auth.auth().currentUser?.uid {
            db.collection("users").document(uid).setData(["selectedHashtags": authViewModel.selectedHashtags], merge: true) { error in
                if let error = error {
                    print("Error saving selected hashtags: \(error)")
                } else {
                    print("Selected hashtags successfully saved!")
                }
            }
        }
    }
    
    private func loadSelectedHashtags() {
        // Get reference to Firebase Firestore
        let db = Firestore.firestore()
        
        // Load the selected hashtags from the user's document in Firestore
        if let uid = Auth.auth().currentUser?.uid {
            db.collection("users").document(uid).getDocument { document, error in
                if let document = document, document.exists, let data = document.data() as? [String: [String]], let savedSelectedHashtags = data["selectedHashtags"] {
                    self.authViewModel.selectedHashtags = savedSelectedHashtags
                } else if let error = error {
                    print("Error loading selected hashtags: \(error)")
                }
            }
        }
    }
}
