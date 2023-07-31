//
//  DropService.swift
//  officalmicdrop
//
//  Created by Leo Juarez on 6/10/23.
//

import Firebase
import AVFoundation
import FirebaseStorage

struct DropService {
    let storage = Storage.storage()
    
    func uploadAudio(_ audioData: Data?, completion: @escaping (Result<URL?, Error>) -> Void) {
        guard let audioData = audioData else {
            // If there's no audio data, we return a success with nil URL.
            completion(.success(nil))
            return
        }
        
        let filename = UUID().uuidString // Generate a unique filename
        let audioRef = storage.reference().child("audioFiles/\(filename).m4a") // Create a reference to the file location
        
        audioRef.putData(audioData, metadata: nil) { _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            audioRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(url))
                }
            }
        }
    }
    
    func uploadImage(_ image: UIImage, completion: @escaping (Result<URL?, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            // If there's no image data, we return a success with nil URL.
            print("Debug: image data is nil.")
            completion(.success(nil))
            return
        }
        
        // print the image data count
        print("Debug: Image data count: \(imageData.count)")
        
        // rest of your code follows...

        
        let filename = UUID().uuidString // Generate a unique filename
        print("Debug: Image filename: \(filename)")
        let imageRef = storage.reference().child("imageFiles/\(filename).jpeg") // Create a reference to the file location
        
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
    
    func uploadDrop(caption: String, images: [UIImage], audioData: Data?, completion: @escaping(Bool) -> Void) {
        let dispatchGroup = DispatchGroup()
        var imageUrls = [URL]()
        
        print("Debug: Number of images to upload: \(images.count)") // Add this 
        for image in images {
            print("Debug: Uploading image.")
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
                print("Debug: Finished uploading all images. Image URLs: \(imageUrls)")
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            if let audioData = audioData {
                self.uploadAudio(audioData) { result in
                    switch result {
                    case .success(let audioURL):
                        self.uploadTextPost(caption: caption, imageUrls: imageUrls, audioURL: audioURL, completion: completion)
                    case .failure(let error):
                        print("Debug: failed to upload audio with error: \(error.localizedDescription)")
                        completion(false)
                    }
                }
            } else {
                self.uploadTextPost(caption: caption, imageUrls: imageUrls, audioURL: nil, completion: completion)
            }
        }
    }
    
    private func uploadTextPost(caption: String, imageUrls: [URL], audioURL: URL?, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var data: [String : Any] = [
            "uid": uid,
            "caption": caption,
            "Stars": 0,
            "timestamp": Timestamp(date: Date()),
            "ratings": [uid: ["5": 0, "4": 0, "3": 0, "2": 0, "1": 0]],  // initialize ratings for the user
            "imageURLs": imageUrls.map({ $0.absoluteString })
        ]
        
        print("Debug: Uploading text post with data: \(data)")
        
        if let audioURL = audioURL {
            data["audioURL"] = audioURL.absoluteString
        }
        
        Firestore.firestore().collection("drops")
            .document().setData(data) { error in
                if let error = error {
                    print("Debug: failed to upload drop with error: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                print("Successfully uploaded drop with caption: \(caption)")
                completion(true)
            }
    }
    
    
    func fetchDrops(completion: @escaping([Drop]) -> Void) {
        Firestore.firestore().collection("drops").order(by: "timestamp", descending: true).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching drops: \(error)")
                return
            }
            guard let documents = snapshot?.documents else { return }
            let drops = documents.compactMap({ try? $0.data(as: Drop.self) })
            print("Debug: Fetched drops: \(drops)")
            completion(drops)
        }
    }
    
    
    func fetchDrops(foruid uid: String, completion: @escaping([Drop]) -> Void) {
        Firestore.firestore().collection("drops")
        
            .whereField("uid", isEqualTo: uid)
        
        
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents else { return }
                let drops = documents.compactMap({ try? $0.data(as: Drop.self) })
                completion(drops.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() }))
            }
    }
    
    func rateStars(dropId: String, stars: Int, completion: @escaping (Bool) -> Void)  {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("Failed to get user id")
            completion(false)
            return
        }

        let docRef = Firestore.firestore().collection("drops").document(dropId)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists, var drop = try? document.data(as: Drop.self) {
                // Initialize user's ratings if not done yet
                if drop.ratings?[uid] == nil {
                    drop.ratings?[uid] = ["5": 0, "4": 0, "3": 0, "2": 0, "1": 0]
                }

                // Check if the user is clicking on a star they've already selected
                if let userRatings = drop.ratings?[uid], userRatings["\(stars)"] == 1 {
                    // If they are, remove their rating for that star
                    drop.ratings?[uid]?["\(stars)"] = 0
                } else {
                    // Otherwise, remove previous rating
                    for (star, _) in drop.ratings?[uid] ?? [:] {
                        if star != String(stars) {
                            drop.ratings?[uid]?[star] = 0
                        }
                    }

                    // Update user's rating
                    drop.ratings?[uid]?["\(stars)"] = 1
                }

                docRef.updateData([
                    "ratings": drop.ratings as Any  // Update ratings
                ]) { err in
                    if let err = err {
                        print("Error updating stars: \(err)")
                        completion(false)
                    } else {
                        print("Stars successfully updated")
                        completion(true)
                    }
                }
            } else {
                print("Document does not exist or failed to decode")
                completion(false)
            }
        }
    }

}
