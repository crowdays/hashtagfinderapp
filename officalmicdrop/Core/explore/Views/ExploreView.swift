//
//  ExploreView.swift
//  officalmicdrop
//
//  Created by Leo Juarez on 5/26/23.
//

import SwiftUI

struct ExploreView: View {
    @ObservedObject var viewModel =  SearchViewModel()
    

    var body: some View {
        VStack {
            SearchBar(text: $viewModel.searchText)
                .padding()
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.searchableUsers) { user in
                        NavigationLink(destination: Profileviews(user: user)) {
                            UserRowView(user: user)
                        }
                    }
                }
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
