//
//  EditHashtagProfileView.swift
//  officalmicdrop
//
//  Created by Leo Juarez on 6/17/23.
//



import SwiftUI
import Kingfisher
import AVFoundation
import PhotosUI


struct EditHashtagProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var profileImages: [UIImage] = []
    @State private var bio: String = ""
    @State private var audio: URL?
    @State private var isShowingImagePicker = false
    @StateObject var viewModel: EditProfileViewModel // Remove the initialization here
    @State private var isRecording = false
    @State private var audioRecorder: AVAudioRecorder?
    @State private var audioPlayer: AVAudioPlayer?
    @State private var isRecordingAvailable = false
    @State private var recordingDuration: Double = 0.0
  
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    isShowingImagePicker = true
                }) {
                    if let image = profileImages.first {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                    } else {
                        Circle()
                            .foregroundColor(.black)
                            .frame(width: 100, height: 100)
                    }
                }
                
                Button(action: {
                    isShowingImagePicker = true
                }) {
                    if profileImages.count > 1 {
                        Image(uiImage: profileImages[1])
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                    } else {
                        Circle()
                            .foregroundColor(.black)
                            .frame(width: 100, height: 100)
                    }
                }
            }
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(selectedImages: $profileImages)
            }
            
            TextField("Enter bio...", text: $bio)
                .onChange(of: bio) { newValue in
                    if newValue.count > 256 {
                        bio = String(newValue.prefix(256))
                    }
                }
                .frame(height: 100)
                .border(Color.gray)
            
            
            // Add these below your existing content
            Button(action: {
                if isRecording {
                    stopRecording()
                } else {
                    startRecording()
                }
            }) {
                Image(systemName: "mic.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(isRecording ? .red : .gray)
            }
            
            ProgressView(value: recordingDuration, total: 30) // Assuming maximum recording duration is 30 seconds
                .progressViewStyle(.linear)
                .padding()
            
            Button(action: startPlayback) {
                Image(systemName: "play.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.gray)
            }
            .disabled(!isRecordingAvailable)
            
            
            
            .onAppear {
                if let profile = viewModel.hashtagProfile {
                    bio = profile.bio
                    profileImages = viewModel.images
                    
                    // Download and assign the audio data if needed
                    if let audioUrlString = profile.voiceMessageUrl, let audioUrl = URL(string: audioUrlString) {
                        URLSession.shared.dataTask(with: audioUrl) { (data, response, error) in
                            if let data = data {
                                let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                                let localAudioUrl = documentPath.appendingPathComponent("downloadedAudio.m4a")
                                do {
                                    try data.write(to: localAudioUrl)
                                    DispatchQueue.main.async {
                                        self.audio = localAudioUrl
                                    }
                                } catch {
                                    print("Error saving audio data: \(error)")
                                }
                            }
                        }.resume()
                    }
                }
            }

        }
        .onDisappear {
            deleteRecording()
        }
        
        
        
        
        Button(action: {
            // Check if the audio file exists
            guard let audioURL = audio, FileManager.default.fileExists(atPath: audioURL.path) else {
                print("Audio file does not exist")
                // Handle this situation (e.g., show an alert to the user)
                return
            }

            // Convert the audio URL to Data
            guard let audioData = try? Data(contentsOf: audioURL) else {
                print("Could not convert audio URL to Data")
                // Handle this situation (e.g., show an alert to the user)
                return
            }

            var imageUrls = [URL]()
            var profile: HashtagProfile?
            var uploadedImagesCount = 0

            // Make sure we have a user before proceeding
            guard let user = viewModel.user else {
                print("User is not set")
                return
            }

            // Upload images and create HashtagProfile
            for image in profileImages {
                viewModel.service.uploadImage(image) { result in
                    switch result {
                    case .success(let url):
                        if let url = url {
                            imageUrls.append(url)
                        }
                    case .failure(let error):
                        print("Failed to upload image: \(error)")
                    }

                    uploadedImagesCount += 1

                    // Check if all images have finished uploading
                    if uploadedImagesCount == profileImages.count {
                        // Create HashtagProfile instance
                        profile = HashtagProfile(dictionary: [
                            "id": UUID().uuidString, // Or use a proper ID
                            "userId": user.id ?? "", // Use the fetched user's ID
                            "bio": bio,
                            "voiceMessageUrl": audio?.absoluteString ?? "",
                            "image1Url": imageUrls[0].absoluteString,
                            "image2Url": imageUrls.count > 1 ? imageUrls[1].absoluteString : ""
                        ])

                        if let profile = profile {
                            // Now we also pass the audio data when saving profile changes
                            viewModel.saveProfileChanges(profile: profile, images: profileImages, audioData: audioData)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
        }) {
            Text("Save Changes")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
        }





        
    }
    
    
    
    func deleteRecording() {
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = documentPath.appendingPathComponent("audioRecording.m4a")
        
        if FileManager.default.fileExists(atPath: audioFilename.path) {
            do {
                try FileManager.default.removeItem(at: audioFilename)
            } catch {
                print("Failed to delete recording: \(error)")
            }
        }
    }
    
    
    
    
    
    func startRecording() {
        let recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            
            let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let audioFilename = documentPath.appendingPathComponent("audioRecording.m4a")
            
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.record()
            
            isRecording = true
            isRecordingAvailable = false
            
            // Add this to start updating the recording duration
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                if let recorder = audioRecorder, recorder.isRecording {
                    recordingDuration = recorder.currentTime
                } else {
                    timer.invalidate()
                }
            }
        } catch {
            print("Could not start recording: \(error)")
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
        isRecording = false
        isRecordingAvailable = true

        // Reset the recording duration
        recordingDuration = 0.0

        // Update the 'audio' state variable to point to the recorded file
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        audio = documentPath.appendingPathComponent("audioRecording.m4a")
    }

    
    func startPlayback() {
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = documentPath.appendingPathComponent("audioRecording.m4a")
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFilename)
            audioPlayer?.play()
        } catch {
            print("Could not start playback: \(error)")
        }
    }
    
    
    
    
    
    
    
    struct EditHashtagProfileView_Previews: PreviewProvider {
        static var previews: some View {
            EditHashtagProfileView(viewModel: EditProfileViewModel())
        }
    }

}
