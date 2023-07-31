//newdropsview
import SwiftUI
import Kingfisher
import AVFoundation


struct NewDropsView: View {
    @State private var title = ""
    @State private var caption = ""
    @State private var isVoiceSelected: Bool = false
    @State private var audioRecorder: AVAudioRecorder?
    @State private var isRecording = false
    @State private var audioPlayer: AVAudioPlayer?
    @State private var isRecordingAvailable = false
    @State private var recordingDuration: Double = 0.0
    @State private var media: [UIImage] = []  // This will store the picked images
    @State private var showingImagePicker = false // Add this line
    @State private var images = [UIImage]() // Add this line
    

    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = UploadDropsViewModel()
    
    var body: some View {
        VStack {
            Group {
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                            .foregroundColor(Color(.systemRed))
                    }
                    Spacer()
                    Button {
                        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                        let audioFilename = documentPath.appendingPathComponent("audioRecording.m4a")
                        
                        var audioData: Data? = nil
                        if FileManager.default.fileExists(atPath: audioFilename.path) {
                            do {
                                audioData = try Data(contentsOf: audioFilename)
                            } catch {
                                print("Error converting URL to Data: \(error)")
                            }
                        }
                        
                        viewModel.uploadDrop(withCaption: caption, withImages: images, audioData: audioData)


                        
                    } label: {
                        Text("Drop")
                            .bold()
                            .padding(.horizontal)
                            .padding(.vertical, 0)
                            .background(Color(.systemGray))
                            .foregroundColor(.black)
                            .clipShape(Capsule())
                    }
                }
                .padding()
                Divider()
                TextField("Title", text: $title)
                    .padding()
                Divider()
                HStack {
                    Button(action: {
                        self.showingImagePicker = true
                    }) {
                        Image(systemName: "paperclip")
                            .foregroundColor(.gray)
                    }
                    .disabled(images.count >= 3)
                    
                    if images.count >= 3 {
                        Text("You have reached the maximum number of images (3).")
                    }
                }
                .padding()
                
                Divider()
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(images.indices, id: \.self) { index in
                            Image(uiImage: images[index])
                                .resizable()
                                .frame(width: 100, height: 100)
                        }
                    }
                }
                .padding()
                Divider()
            }
            
            Group {
                HStack {
                    Toggle(isOn: $isVoiceSelected) {
                        Image(systemName: isVoiceSelected ? "mic" : "t.square.fill")
                    }
                    .toggleStyle(.button)
                    .frame(width: 64, height: 64)
                    .padding(.trailing, 8)
                    
                    if !isVoiceSelected {
                        Textarea("What do you want to say?", text: $caption)
                            .frame(height: 150) // Adjust this height based on your requirements
                    }
                }
                .padding()
                
                if isVoiceSelected {
                    VStack {
                        Divider()
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
                        
                        
                        
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .edgesIgnoringSafeArea(.all)
                }
                Spacer()  // Add this to push the content upwards
                Divider()
            }
            .onReceive(viewModel.$didUploadDrop) { success in
                if success {
                    presentationMode.wrappedValue.dismiss()
                    
                }
                
            }
            .onDisappear {
                deleteRecording()
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(selectedImages: $images)
            }
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
        
    }
    

