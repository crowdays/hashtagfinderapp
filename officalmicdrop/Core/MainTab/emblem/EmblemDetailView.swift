//
//  EmblemDetailView.swift
//  officalmicdrop
//
//  Created by Leo Juarez on 7/23/23.
//

import SwiftUI

struct EmblemDetailView: View {
    var emblem: Emblem?

    var body: some View {
        if let emblem = emblem {
            VStack {
                Circle()
                    .frame(width: 100, height: 100)
                    .overlay(EmblemView(squares: emblem.squares.map { Color($0) }))
                Text(emblem.name)
                    .font(.title)
                Text(emblem.bio)
                    .font(.body)
                Divider()
            }
        } else {
            Text("No emblem selected")
        }
    }
}


