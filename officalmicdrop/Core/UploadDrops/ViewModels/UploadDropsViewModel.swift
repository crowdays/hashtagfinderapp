//
//  UploadDropsViewModel.swift
//  officalmicdrop
//
//  Created by Leo Juarez on 6/10/23.
//

// UploadDropsViewModel.swift
import Foundation
import UIKit

class UploadDropsViewModel: ObservableObject {
    @Published var didUploadDrop = false
    let service = DropService()
    
    func uploadDrop(withCaption caption: String, withImages images: [UIImage], audioData: Data?) {
        service.uploadDrop(caption: caption, images: images, audioData: audioData) { success in
            if success {
                self.didUploadDrop = true
            } else {
                print("Error uploading drop")
            }
        }
    }
}
