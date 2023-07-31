import SwiftUI
import Kingfisher
import AVFoundation






struct HashtagDetailView: View {
    @State private var selectedUserIndex: Int = 0 {
        didSet {
            fetchHashtagProfile()
        }
    }
    @StateObject var viewModel: HashtagDetailViewModel
    @State private var showFilterBar = false
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var rotationDegrees: Double = 0
    @State private var rotationDegrees2: Double = 0
    @State var hashtagProfile: HashtagProfile?
    @State private var navigateToHashtagMessagesView = false
    @ObservedObject var messagesViewModel = HashtagMessagesViewModel()
    @State private var navigateToChatView = false
    
    
    
    
    init(authViewModel: AuthViewModel, hashtagProfile: HashtagProfile? = nil) {
        _viewModel = StateObject(wrappedValue: HashtagDetailViewModel(authViewModel: authViewModel))
        _hashtagProfile = State(initialValue: hashtagProfile)
    }
    
    // Add this function to fetch the HashtagProfile
    func fetchHashtagProfile() {
        if !viewModel.filteredUsers.isEmpty {
            let user = viewModel.filteredUsers[selectedUserIndex]
            print("Selected user index: \(selectedUserIndex), User data: \(user)") // Add this line
            Task {
                hashtagProfile = await viewModel.getHashtagProfile(for: user)
            }
        }
    }
    
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        Button(action: {
                            navigateToHashtagMessagesView = true
                            navigateToChatView = true
                        }) {
                            Image(systemName: "envelope.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 36, height: 36)
                                .foregroundColor(Color(red: 1.00, green: 0.84, blue: 0.00))
                        }
                        .contentShape(Rectangle())
                        .padding(.leading)
                        .padding(.top, -3)
                        
                        Spacer()
                        
                        NavigationLink(destination: HashtagProfileView()) {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 36, height: 36)
                                .padding(.leading)
                                .foregroundColor(Color(.black))
                                .shadow(color: .gray, radius: 5, x: 0, y: 5)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            showFilterBar = true
                        }) {
                            Image(systemName: "slider.horizontal.3")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 36, height: 36)
                                .padding(.trailing)
                                .foregroundColor(Color(red: 1.00, green: 0.84, blue: 0.00))
                        }
                    }
                    .padding(.top, -135)
                    
                    Divider().padding(.top, -60)
                    
                    NavigationLink(
                        destination: HashtagMessagesView(),
                        isActive: $navigateToHashtagMessagesView
                    ) {
                        EmptyView()
                    }.hidden()
                    
                        .padding(.top)
                    
                    if viewModel.filteredUsers.isEmpty {
                        VStack {
                            
                            
                            Rectangle()
                                .stroke(Color.black, lineWidth: 2)
                                .frame(width: 250, height: 340)
                                .shadow(color: .black, radius: 10, x: 0, y: 5)
                                .offset(x:0, y:-60)
                            
                            Text("Pick a hashtag to show users")
                                .font(.subheadline)
                                .bold()
                                .offset(x:0, y:-50)
                            
                            
                        }
                    } else {
                        let user = viewModel.filteredUsers[selectedUserIndex]
                        let distance = viewModel.userDistances[user.id ?? ""]
                        VStack {
                            
                            if let distance = viewModel.userDistances[user.id ?? ""] {
                                Text(String(format: "%.1f miles away", distance))
                            }
                            
                            
                            
                            
                            NavigationLink(destination: Profileviews(user: user)) {
                                KFImage(URL(string: user.profileImageUrl))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 150, height: 150)
                                    .clipShape(Circle())
                            }
                            
                            
                            Text(user.fullname)
                                .bold()
                            
                            Text(user.username)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Divider()
                            
                            VStack {
                                ScrollView {
                                    VStack {
                                        if let profile = hashtagProfile {
                                            Text(profile.bio)
                                                .font(.body)
                                            
                                            if let url = URL(string: profile.image1Url) {
                                                KFImage(url)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 250, height: 250)
                                            }
                                            
                                            // Hashtag profile image2
                                            if let url = URL(string: profile.image2Url) {
                                                KFImage(url)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 250, height: 250)
                                            }
                                            
                                            // Add player view if voice message URL is available
                                            if let voiceMessageUrl = profile.voiceMessageUrl,
                                               let audioURL = URL(string: voiceMessageUrl) {
                                                PlayerView(audioURL: audioURL)
                                            } else {
                                                Text("No Audio URL")
                                            }
                                        } else {
                                            Text("No HashtagProfile")
                                        }
                                    }
                                }
                            }
                            
                            .frame(height: 125) // you can adjust this to fit your needs
                            Divider()
                        }
                        
                        
                        
                        
                        HStack {
                            Button(action: {
                                if selectedUserIndex > 0 {
                                    selectedUserIndex -= 1
                                    print("Previous button clicked, new selected user index: \(selectedUserIndex)")
                                    
                                }
                            }) {
                                ZStack {
                                    
                                    Circle()
                                        .foregroundColor(.black)
                                        .frame(width: 50, height: 50)
                                        .offset(x: 32)
                                    Circle()
                                        .stroke(Color(red: 1.00, green: 0.84, blue: 0.00), lineWidth: 4)
                                        .frame(width: 55, height: 55)
                                        .offset(x: 32)
                                    
                                    Image(systemName: "arrowshape.backward")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 35, height: 35)
                                        .padding(.leading)
                                        .foregroundColor(Color(.white))
                                        .offset(x: 25)
                                }
                            }
                            Spacer()
                            Button(action: {
                                print("Attempting to navigate to ChatView, Selected user index: \(selectedUserIndex), User data: \(viewModel.filteredUsers[selectedUserIndex])")
                                navigateToChatView = true
                                print("Mail icon clicked, navigateToChatView set to true")
                                print("Selected user: \(viewModel.filteredUsers[selectedUserIndex])")
                            }) {
                                NavigationLink(
                                    destination: ChatView(user: viewModel.filteredUsers[selectedUserIndex], viewModel: messagesViewModel),
                                    isActive: $navigateToChatView
                                ) {
                                    EmptyView()
                                    
                                    
                                    ZStack {
                                        GeometryReader { geometry in
                                            Path { path in
                                                let size = min(geometry.size.width, geometry.size.height)
                                                let triangleHeight = size * sqrt(3) / 2
                                                let triangleOffset = (size - triangleHeight) / 2
                                                
                                                path.move(to: CGPoint(x: size / 2, y: triangleOffset))
                                                path.addLine(to: CGPoint(x: size, y: size - triangleOffset))
                                                path.addLine(to: CGPoint(x: 0, y: size - triangleOffset))
                                                path.closeSubpath()
                                            }
                                            .foregroundColor(Color(red: 1.00, green: 0.84, blue: 0.00))  // RGB for Gold
                                            .frame(width: geometry.size.width, height: geometry.size.height)
                                            .rotation3DEffect(.degrees(rotationDegrees), axis: (x: 0, y: 0, z: 1))  // Apply rotation here
                                        }
                                        .onAppear {
                                            withAnimation(Animation.linear(duration: 5).repeatForever(autoreverses: false)) {
                                                rotationDegrees = 360
                                            }
                                        }
                                        
                                        GeometryReader { geometry in
                                            Path { path in
                                                let size = min(geometry.size.width, geometry.size.height)
                                                let triangleHeight = size * sqrt(3) / 2
                                                let triangleOffset = (size - triangleHeight) / 2
                                                
                                                path.move(to: CGPoint(x: size / 2, y: triangleOffset))
                                                path.addLine(to: CGPoint(x: size, y: size - triangleOffset))
                                                path.addLine(to: CGPoint(x: 0, y: size - triangleOffset))
                                                path.closeSubpath()
                                            }
                                            .foregroundColor(.black)  // Different color for the second triangle
                                            .frame(width: geometry.size.width, height: geometry.size.height)
                                            .rotation3DEffect(.degrees(rotationDegrees2), axis: (x: 0, y: 0, z: 1))  // Apply rotation here
                                        }
                                        .onAppear {
                                            withAnimation(Animation.linear(duration: 5).repeatForever(autoreverses: false)) {
                                                rotationDegrees2 = -360  // Rotate in the opposite direction
                                            }
                                        }
                                        
                                        
                                        Image(systemName: "envelope.circle.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 25, height: 25)
                                            .foregroundColor(.white)
                                    }
                                }
                                .frame(width: 70, height: 70) // Adjust the button size as needed
                                .offset(x: 5, y: 50) // Offset the button to position it on top of the triangle
                            }
                            Spacer()
                            Button(action: {
                                if selectedUserIndex < viewModel.filteredUsers.count - 1 {
                                    selectedUserIndex += 1
                                    print("Next button clicked, new selected user index: \(selectedUserIndex)")
                                    print("Selected user: \(viewModel.filteredUsers[selectedUserIndex])") // Add this line
                                }
                            }) {
                                ZStack {
                                    Circle()
                                        .foregroundColor(.black)
                                        .frame(width: 50, height: 50)
                                        .offset(x: -32)
                                    Circle()
                                        .stroke(Color(red: 1.00, green: 0.84, blue: 0.00), lineWidth: 4)
                                        .frame(width: 55, height: 55)
                                        .offset(x: -32)
                                    
                                    Image(systemName: "arrowshape.forward")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 35, height: 35)
                                        .padding(.leading)
                                        .foregroundColor(Color(.white))
                                        .offset(x: -38)
                                }
                            }
                        }
                        
                        
                        .padding(.bottom)
                    }
                    if showFilterBar {
                        NavigationLink(
                            destination: FilterBarView(hashtagViewModel: viewModel)
                                .environmentObject(authViewModel),
                            isActive: $showFilterBar,
                            label: {
                                EmptyView()
                            }
                        )
                        .hidden()
                        
                        
                    }
                }
                
                .onAppear {
                    print("onAppear: start")
                    print("onAppear: authViewModel.selectedHashtags - \(authViewModel.selectedHashtags)")
                    print("onAppear: selectedUserIndex - \(selectedUserIndex)")
                    print("onAppear: navigateToChatView - \(navigateToChatView)")
                    viewModel.filterUsers()
                    fetchHashtagProfile()
                }
                
            }
            
        }
        
        
    }
    
    
    
    
    
    
    
    
}
