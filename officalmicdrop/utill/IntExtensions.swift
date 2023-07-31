//
//  IntExtensions.swift
//  officalmicdrop
//
//  Created by Leo Juarez on 6/14/23.
//

import Foundation

extension Int {
    func toKMB() -> String {
        if self > 999_999_999 || self < -999_999_999 {
            return String(format: "%.3fB", Double(self) / 1_000_000_000)
        } else if self > 999_999 || self < -999_999 {
            return String(format: "%.2fM", Double(self) / 1_000_000)
        } else if self > 999 || self < -999 {
            return String(format: "%.1fK", Double(self) / 1_000)
        } else {
            return String(self)
        }
    }
}

