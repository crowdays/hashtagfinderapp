//
//  FeedView.swift
//  officalmicdrop
//
//  Created by Leo Juarez on 5/23/23.
//

import SwiftUI



struct FeedView: View {
    @ObservedObject var viewModel = FeedViewModel()
    @StateObject var ratingManager = RatingManager()
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.drops) { drop in
                    let tweetRowViewModel = TweetRowViewModel(drop: drop, ratingManager: ratingManager)
                    TweetsRowView(viewModel: tweetRowViewModel, drop: drop)
                        .padding()
                }
            }
        }
    }
}





struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
