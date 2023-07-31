
//tweetrowview
import SwiftUI
import Kingfisher



struct StarView: View {
    
    var number: Int
    @ObservedObject var viewModel: TweetRowViewModel
    @EnvironmentObject var ratingManager: RatingManager

    
    var body: some View {
        
            Button(action: {
                print("Star \(number) clicked")
                viewModel.rateStar(stars: number)
                let userRating = Int(viewModel.userRating ?? "0") ?? 0
                print("User rating: \(userRating)")
            }) {
                HStack {
                    // Determine whether the star should be filled based on the user's rating
                    let userRating = Int(viewModel.userRating ?? "0") ?? 0
                    let imageName = number == userRating ? "star.fill" : "star"
                    let color = number == userRating ? Color.yellow : Color.gray
                    
                    Image(systemName: imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(color)
                }
            }
        }
    }

    
    struct TweetsRowView: View {
        @State private var starClicked: Bool = false
        @StateObject private var player = AVPlayerWrapper()
        @ObservedObject var viewModel: TweetRowViewModel
        let drop: Drop
        
        var body: some View {
            VStack(alignment: .leading) {
                
                
                if let user = drop.user {
                    
                    HStack(alignment: .top, spacing: 12) {
                        KFImage(URL(string: user.profileImageUrl))
                        
                            .resizable()
                            .scaledToFill()
                            .frame(width: 56, height: 56)
                            .clipShape(Circle())
                        
                        
                        
                        VStack(alignment: .leading, spacing: 4) {
                            
                            
                            
                            HStack {
                                
                                
                                Text(user.username)
                                    .foregroundColor(.gray)
                                    .font(.caption)
                                Circle()
                                    .frame(width: 15, height: 15)
                                    .foregroundColor(Color(.systemGray3))
                                Text("- 2w")
                                    .foregroundColor(.gray)
                                    .font(.caption)
                                Spacer()
                                Button(action: {
                                    // Your code for report, etc.
                                }) {
                                    Image(systemName: "ellipsis")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            
                            Text(drop.caption) // instead of Text(drop.caption)
                                .font(.subheadline)
                                .multilineTextAlignment(.leading)
                            
                            if let imageURLs = drop.imageURLs, !imageURLs.isEmpty {
                                CarouselView(images: imageURLs.map { KFImage(URL(string: $0)) })
                                    .frame(height: 200) // adjust this height according to your needs
                            }


                        }
                    }
                    // Add the audio playback button here
                    if let audioURLString = drop.audioURL, let audioURL = URL(string: audioURLString) {
                        PlayerView(audioURL: audioURL)
                    } else {
                        // Handle the case where there's no associated audio recording.
                        // You might want to display the text post differently in this case.
                    }


                    
                }
                HStack {
                    Button{
                        
                    } label: {
                        Image(systemName: "music.mic.circle.fill")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Button {
                        
                    } label: {
                        Image(systemName: "square.and.arrow.down")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Button {
                        starClicked.toggle()
                    } label: {
                        Image(systemName: "star.leadinghalf.filled")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    if starClicked {
                        VStack {
                            ForEach((1...5).reversed(), id: \.self) { i in
                                HStack {
                                    Text("\(i)")
                                    StarView(number: i, viewModel: viewModel)  // Pass in the viewModel
                                    Text("\(viewModel.aggregateRatings[String(i), default: 0].toKMB())")
                                        .font(.caption)
                                }
                            }
                        }
                    }



                    Spacer()
                    Button {
                        
                    } label: {
                        Image(systemName: "bookmark")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Button {
                        
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                
                Divider()
                
            }
            .onAppear {
                print("TweetsRowView is being loaded")
            }
        }
    }

