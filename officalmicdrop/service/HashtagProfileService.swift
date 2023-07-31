//
//  HashtagProfileService.swift
//  officalmicdrop
//
//  Created by Leo Juarez on 6/17/23.
//

import Firebase
import FirebaseStorage
import FirebaseFirestoreSwift

class HashtagProfileService {
    static let shared = HashtagProfileService()
    private let storage = Storage.storage()
    private init() {}
    
    func fetchHashtagProfile(userId: String, completion: @escaping (HashtagProfile) -> Void) {
        Firestore.firestore().collection("hashtagProfiles").document(userId).getDocument { snapshot, error in
            guard let dictionary = snapshot?.data() else { return }
            let profile = HashtagProfile(dictionary: dictionary)
            completion(profile)
        }
    }
    
    func uploadAudio(_ audioData: Data?, completion: @escaping (Result<URL?, Error>) -> Void) {
        guard let audioData = audioData else {
            print("Debug: audioData is nil")
            completion(.success(nil))
            return
        }
        let filename = UUID().uuidString
        let audioRef = storage.reference().child("audioFiles/\(filename).m4a")
        audioRef.putData(audioData, metadata: nil) { _, error in
            if let error = error {
                print("Debug: failed to upload audio with error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            audioRef.downloadURL { url, error in
                if let error = error {
                    print("Debug: failed to get download URL with error: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    print("Debug: successfully uploaded audio, download URL: \(url?.absoluteString ?? "nil")")
                    completion(.success(url))
                }
            }
        }
    }

    
    func uploadImage(_ image: UIImage, completion: @escaping (Result<URL?, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(.success(nil))
            return
        }
        let filename = UUID().uuidString
        let imageRef = storage.reference().child("imageFiles/\(filename).jpeg")
        imageRef.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            imageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(url))
                }
            }
        }
    }
    
    func updateHashtagProfile(profile: HashtagProfile, images: [UIImage], audioData: Data?, completion: @escaping (Bool) -> Void) {
            let dispatchGroup = DispatchGroup()
            var imageUrls = [URL]()
        
        if audioData == nil {
            print("Debug: audioData is nil in updateHashtagProfile")
        }
            
            for image in images {
                dispatchGroup.enter()
                uploadImage(image) { result in
                    switch result {
                    case .success(let imageURL):
                        if let imageURL = imageURL {
                            imageUrls.append(imageURL)
                        }
                    case .failure(let error):
                        print("Debug: failed to upload image with error: \(error.localizedDescription)")
                    }
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                if let audioData = audioData {
                    self.uploadAudio(audioData) { result in
                        switch result {
                        case .success(let audioURL):
                            self.updateHashtagProfileInFirestore(profile: profile, imageUrls: imageUrls, audioURL: audioURL, completion: completion)
                        case .failure(let error):
                            print("Debug: failed to upload audio with error: \(error.localizedDescription)")
                        }
                    }
                } else {
                    self.updateHashtagProfileInFirestore(profile: profile, imageUrls: imageUrls, audioURL: nil, completion: completion)
                }
            }
        }

    private func updateHashtagProfileInFirestore(profile: HashtagProfile, imageUrls: [URL], audioURL: URL?, completion: @escaping (Bool) -> Void) {
        var data = profile.dictionary
        if let imageUrl1 = imageUrls.first?.absoluteString {
            data["image1Url"] = imageUrl1
        }
        if imageUrls.count > 1 {
            data["image2Url"] = imageUrls[1].absoluteString
        }
        data["voiceMessageUrl"] = audioURL?.absoluteString  // Updated line
            
        Firestore.firestore().collection("hashtagProfiles").document(profile.userId).setData(data) { error in
            if let error = error {
                print("Debug: failed to update profile with error: \(error.localizedDescription)")
                completion(false)
                return
            }
            completion(true)
        }
    }


    }
