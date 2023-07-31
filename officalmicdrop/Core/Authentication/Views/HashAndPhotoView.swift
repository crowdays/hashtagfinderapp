//
//  HashAndPhotoView.swift
//  officalmicdrop
//
//  Created by Leo Juarez on 6/3/23.
//

import SwiftUI
import Kingfisher


struct HashAndPhotoView: View {
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var profileImage: Image?
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var selectedTags = [String]()
    @State private var inputText = ""
    @State private var allTags = [
        "Piano", "Guitar", "Drums", "Violin", "Tattoo artist", "Planter", "Male", "Plumber", "Driver" , "Female", "Nail", "Hair Braider"
        
    ]
    @State private var reselectedTag: String?
    
    
    
    func loadImage() {
        guard let selectedImage = selectedImage else { return }
        profileImage = Image(uiImage: selectedImage)
        
    }
    
    
    var body: some View {
        
        
        
        VStack {
            AuthenticationHeaderView(title1: "Setup 5 hashtags ",
                                     title2: "With a profile photo")
            
            Button {
                showImagePicker.toggle()
                
            } label: {
                if let profileImage = profileImage {
                    profileImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 140, height: 140)
                        .clipShape(Circle())
                    
                } else {
                    
                    Image("micdropuploadphoto")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                        
                        .clipShape(Circle())
                    
                }
            }
            .sheet(isPresented: $showImagePicker, onDismiss: loadImage) {
                SingleImagePicker(selectedImage: $selectedImage)
            }

            
            Spacer()
    
           
        

            
            TextField("5 Hashtags that best describes your account", text: $inputText)
                .padding()
                .border(Color.gray, width: 0.5)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(selectedTags, id: \.self) { tag in
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
                                    selectedTags.removeAll(where: { $0 == tag })
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
                        if !selectedTags.contains(tag) {
                            Text(tag)
                                .padding()
                                .background(Color.white)
                                .foregroundColor(.black)
                                .cornerRadius(15)
                                .onTapGesture {
                                    if selectedTags.count < 5 {
                                        selectedTags.append(tag)
                                    }
                                }
                        }
                    }
                }
               
            }

            if let selectedImage = selectedImage, selectedTags.count == 5 {
                Button {
                    viewModel.uploadProfileImage(selectedImage, hashtags: selectedTags)
                } label: {
                    Text("Create")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 340, height: 50)
                        .background(Color(.black))
                        .clipShape(Capsule())
                        .padding()
                }
                .shadow(color: .black.opacity(0.5), radius: 10, x:0, y: 0 )
                .padding(150)
            }
            Spacer()
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
    }
}

struct HashAndPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        HashAndPhotoView()
    }
}
