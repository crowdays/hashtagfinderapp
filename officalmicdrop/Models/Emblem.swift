//
//  Emblem.swift
//  officalmicdrop
//
//  Created by Leo Juarez on 7/23/23.
//

import Foundation
import SwiftUI

struct Emblem: Codable, Identifiable {
    var id: String = UUID().uuidString
    var name: String
    var squares: [String] // Change this to String
    var bio: String
}



