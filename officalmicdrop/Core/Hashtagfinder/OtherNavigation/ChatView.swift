//  ChatView.swift
//  officalmicdrop
//
//  Created by Leo Juarez on 6/22/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct ChatView: View {
    var user: User
    @ObservedObject var viewModel: HashtagMessagesViewModel
    @State private var messageText = ""
   
    init(user: User, viewModel: HashtagMessagesViewModel) {
        self.user = user
        self.viewModel = viewModel
        print("ChatView initialized with user: \(user.username)")
    }

    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                // Message List
                ScrollView {
                    ForEach(viewModel.messages) { message in
                        MessageRow(
                            message: message,
                            isCurrentUser: message.senderId == Auth.auth().currentUser?.uid
                        )
                    }
                }
                
                .padding(.bottom, 10) // Add padding at the bottom
                
                Spacer()
                
                // Message Input
                HStack {
                    TextField("Message...", text: $messageText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: {
                        if let currentUserId = Auth.auth().currentUser?.uid, let recipientId = user.id {
                            let conversationId = viewModel.getConversationId(user1Id: currentUserId, user2Id: recipientId)
                            viewModel.sendMessage(messageText, imageURL: nil, audioURL: nil, to: recipientId, in: conversationId)
                            messageText = ""
                        }
                    }) {
                        Text("Drop")
                    }
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .clipShape(Circle())
                }
                .padding()
                .offset(y: -45) // push text bar up by 20 units
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .onAppear {
                print("ChatView has appeared")
                if let currentUserId = Auth.auth().currentUser?.uid, let recipientId = user.id {
                    viewModel.fetchMessagesForUser(currentUserId: currentUserId, recipientId: recipientId)
                }
            }

        }
    }
    
    struct MessageRow: View {
        var message: HashtagMessage
        var isCurrentUser: Bool

        var body: some View {
            HStack {
                if isCurrentUser {
                    Spacer() // Push the content to the right for current user
                }
                Text(message.content)
                    .padding()
                    .background(isCurrentUser ? Color(red: 1.00, green: 0.84, blue: 0.00) : Color.black) // RGB for Gold for current user, Black for others
                    .foregroundColor(isCurrentUser ? .black : .white) // Black text for current user, White for others
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                if !isCurrentUser {
                    Spacer() // Push the content to the left for other users
                }
            }
            .padding(.horizontal)
        }
    }

}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a mock User object
        let mockUser = User(
            id: "testUserID", username: "TestUser",
            fullname: "Test User",
            profileImageUrl: "https://example.com/image.jpg",
            email: "test@example.com",
            hashtags: ["test1", "test2"],
            latitude: 0.0, // replace with appropriate value
            longitude: 0.0 // replace with appropriate value
        )
        
        // Create a mock HashtagMessagesViewModel object
        let mockViewModel = HashtagMessagesViewModel() // replace with actual initialization

        // Pass the mock User and mock HashtagMessagesViewModel to ChatView
        ChatView(user: mockUser, viewModel: mockViewModel)
    }
}
