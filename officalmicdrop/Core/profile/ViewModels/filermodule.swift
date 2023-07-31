//
//  filermodule.swift
//  officalmicdrop
//
//  Created by Leo Juarez on 5/25/23.
//

import Foundation

enum filtermodule: Int, CaseIterable {
    case posts
    case drops
    case media
    case ratings
    
    var title: String {
        switch self {
        case .posts: return "Posts"
        case .drops: return "Drops"
        case .media: return "Media"
        case .ratings: return "Ratings"
        }
    }
}
