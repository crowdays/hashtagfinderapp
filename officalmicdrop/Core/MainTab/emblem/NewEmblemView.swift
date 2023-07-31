//
//  NewEmblemView.swift
//  officalmicdrop
//
//  Created by Leo Juarez on 7/23/23.
//

import SwiftUI

struct NewEmblemView: View {
    @State private var name: String = ""
    @Binding var emblems: [Emblem]

    var body: some View {
        VStack {
            TextField("Enter emblem name", text: $name)
                .padding()
                .border(Color.gray, width: 0.5)

            NavigationLink(destination: EmblemCreationView(emblems: $emblems, name: name)) {
                Text("Create")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
}

