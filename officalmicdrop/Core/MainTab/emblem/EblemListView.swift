//
//  EblemListView.swift
//  officalmicdrop
//
//  Created by Leo Juarez on 7/23/23.
//

import SwiftUI

struct EmblemListView: View {
    @State var emblems: [Emblem] = []

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(emblems) { emblem in
                        HStack {
                            EmblemView(squares: emblem.squares.map { Color($0) })
                            Text(emblem.name)
                            NavigationLink(destination: EmblemCreationView(emblems: $emblems, emblem: emblem, name: emblem.name)) {
                                Image(systemName: "pencil.circle")
                            }
                            NavigationLink(destination: EmblemDetailView(emblem: emblem)) {
                                Image(systemName: "info.circle")
                            }
                        }
                    }
                }
                NavigationLink(destination: NewEmblemView(emblems: $emblems)) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.blue)
                        .imageScale(.large)
                }
            }
            .navigationTitle("Emblems")
            .onAppear {
                UserService().loadEmblems { emblems in
                    self.emblems = emblems
                }
            }
        }
    }
}
