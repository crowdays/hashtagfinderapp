
//profileviews
import SwiftUI
import Kingfisher

struct Profileviews: View {
    @State private var selectedFilter: filtermodule = .posts
    @Namespace var animation
    @ObservedObject var viewModel: ProfileViewModel
    @EnvironmentObject var ratingManager: RatingManager
    
    
    @State private var showHashtags: Bool = false

    init(user: User) {
        self.viewModel = ProfileViewModel(user: user)
    }
    
    var body: some View {
            VStack {
                headerView
                actionButtons
                userInfoDetails
                filterBar
                dropsview
                Spacer()
            }
            .sheet(isPresented: $showHashtags) {
                HashtagsView(hashtags: self.viewModel.user.hashtags)
            }
        }

        var headerView: some View {
            ZStack(alignment: .topTrailing) {
                Color(.systemGray3).ignoresSafeArea()
                KFImage(URL(string: viewModel.user.profileImageUrl))
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 72, height: 72)
                    .offset(x:-45, y:65)
            }
            .frame(height: 96)
        }

    var actionButtons: some View {
        VStack {
            HStack {
                Spacer()

                Button(action: {
                    self.showHashtags = true
                }) {
                    Image(systemName: "number.circle.fill")
                        .font(.title3)
                        .padding(.horizontal, 100)
                        .padding(.vertical, 4)
                }
            }
            .padding(.trailing)

            if viewModel.user.isCurrentUser {
                NavigationLink(destination: EditProfileView(user: viewModel.user)) {
                    Text("Edit")
                        .font(.title3)
                        .padding(6)
                }
                .offset(x:150, y:-150)
            } else if viewModel.following.contains(viewModel.user.id ?? "") {
                Button(action: {
                    viewModel.unfollowUser()
                }) {
                    Text("Unfollow")
                        .font(.title3)
                        .padding(6)
                }
                .offset(x:150, y:-150)
            } else {
                Button(action: {
                    viewModel.followUser()
                }) {
                    Text("Follow")
                        .font(.title3)
                        .padding(6)
                }
                .offset(x:150, y:-150)
            }
        }
        .padding(.trailing)
    }

        
    var userInfoDetails: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(viewModel.user.fullname)
                .bold()
                .offset(x:-45, y:-113)

            Text(viewModel.user.username)
                .font(.subheadline)
                .foregroundColor(.gray)
                .offset(x:220, y:-70)

            Text("Voice message...")
                .offset(x:-45, y:-130)

            Text(viewModel.user.bio ?? "No bio available")

                .font(.subheadline)
                .padding(.vertical)
                .offset(x:-45, y:-145)

            HStack(spacing: 24) {
                HStack(spacing: 4) {
                    Text("\(viewModel.followers.count)").font(.subheadline) // Replace hardcoded text
                        .bold()
                        .offset(x:-50, y:-160)
                    Text("Followers")
                        .font(.caption)
                        .offset(x:-50, y:-160)
                        .foregroundColor(.gray)
                }

                HStack(spacing: 4) {
                    Text("\(viewModel.following.count)").font(.subheadline) // Replace hardcoded text
                        .bold()
                        .offset(x:-15, y:-160)
                    Text("Following")
                        .font(.caption)
                        .offset(x:-15, y:-160)
                        .foregroundColor(.gray)
                }

                HStack(spacing: 4) {
                    Text("15").font(.subheadline)
                        .bold()
                        .offset(x:30, y:-160)
                    Text("Labels")
                        .font(.caption)
                        .offset(x:30, y:-160)
                        .foregroundColor(.gray)
                }
            }
            .padding(.vertical)
        }
    }

    
    var filterBar: some View {
        // Apply offset here
        HStack(spacing: 0) {
            ForEach(filtermodule.allCases, id: \.self) { item in
                VStack {
                    Text(item.title)
                        .font(.subheadline)
                        .fontWeight(selectedFilter == item ? .semibold : .regular)
                        .foregroundColor(selectedFilter == item ? .black : .gray)
                }
                .padding()
                .frame(maxWidth: .infinity) // Makes each column the same width
                .background(
                    Color(selectedFilter == item ? .systemGray5 : .clear)
                        .matchedGeometryEffect(id: "filter", in: animation, isSource: selectedFilter == item)
                )
                .border(Color.gray.opacity(0.5), width: 0.5) // Adds vertical dividers
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        self.selectedFilter = item
                    }
                }
            }
        }
        .padding(.top, -160)
    }
    var dropsview: some View {
        
        ScrollView {
            LazyVStack {
                ForEach(viewModel.drops) { drop in
                    let tweetRowViewModel = TweetRowViewModel(drop: drop, ratingManager: ratingManager)
                    TweetsRowView(viewModel: tweetRowViewModel, drop: drop)
                        .padding(.top)
                }
            }
            .navigationBarHidden(true)
        }

    }
    
    
   
    
        
}

struct Profileviews_Previews: PreviewProvider {
    static var previews: some View {
        Profileviews(user: User(id: NSUUID().uuidString,
                                username: "batman",
                                fullname: "bruce",
                                profileImageUrl: "",
                                email: "batman@gmail.com",
                                hashtags: [""],
                                latitude: 0.0,
                                longitude: 0.0,
                                hashtagProfile: nil))

    }
}





     
