//
//  RatingManager.swift
//  officalmicdrop
//
//  Created by Leo Juarez on 6/14/23.
//

import Combine

class RatingManager: ObservableObject {
    @Published var ratings: [String: [String: Int]] = [:]
}

