//  HashtagMessagesView.swift
//  officalmicdrop
//
//  Created by Leo Juarez on 6/22/23.
//

import SwiftUI
import Kingfisher
import Firebase

struct HashtagMessagesView: View {
    @ObservedObject var viewModel = HashtagMessagesViewModel()
    @ObservedObject var searchViewModel = SearchViewModel()

    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                SearchBar(text: $searchViewModel.searchText)
                    .padding(.horizontal)

                // User List
                List {
                    ForEach(searchViewModel.searchableUsers, id: \.id) { user in
                        NavigationLink(destination: ChatView(user: user, viewModel: viewModel)) {
                            HStack {
                                // Use Kingfisher to load the user's profile image
                                KFImage(URL(string: user.profileImageUrl))
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                VStack(alignment: .leading) {
                                    Text(user.username)
                                    // Display the last message for each user
                                    Text(user.lastMessage?.content ?? "")
                                        .lineLimit(1)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Messages")
        }
    }
}


struct MessageDetailView: View {
    let message: HashtagMessage

    var body: some View {
        // Here you can define the view for a single message
        Text(message.content)
    }
}

struct HashtagMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        HashtagMessagesView()
    }
}
