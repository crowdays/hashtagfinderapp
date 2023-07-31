//
//  HashtagProfile.swift
//  officalmicdrop
//
//  Created by Leo Juarez on 6/17/23.
//

import Foundation


struct HashtagProfile: Identifiable, Decodable {
    let id: String
    let userId: String
    let bio: String
    let voiceMessageUrl: String?
    let image1Url: String
    let image2Url: String

    var dictionary: [String: Any] {
        return [
            "id": id,
            "userId": userId,
            "bio": bio,
            "voiceMessageUrl": voiceMessageUrl ?? "",  // use an empty string as the default value
            "image1Url": image1Url,
            "image2Url": image2Url
        ]
    }

    
    init(dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? ""
        self.userId = dictionary["userId"] as? String ?? ""
        self.bio = dictionary["bio"] as? String ?? ""
        self.voiceMessageUrl = dictionary["voiceMessageUrl"] as? String ?? ""
        self.image1Url = dictionary["image1Url"] as? String ?? ""
        self.image2Url = dictionary["image2Url"] as? String ?? ""
    }
}
