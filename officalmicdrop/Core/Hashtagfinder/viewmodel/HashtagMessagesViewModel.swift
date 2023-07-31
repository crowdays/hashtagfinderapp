import Combine
import Firebase
import FirebaseFirestoreSwift

class HashtagMessagesViewModel: ObservableObject {
    @Published var messages = [HashtagMessage]()
    var cancellables = Set<AnyCancellable>()
    private var service = HashtagMessageService()
    private let user = Auth.auth().currentUser // Assumes you have Firebase Authentication setup
    
    func fetchMessages(in conversationId: String) {
            service.fetchMessages(in: conversationId).sink { [self] completion in
                switch completion {
                case .finished:
                    print("Messages fetched successfully")
                case .failure(let error):
                    print("Failed to fetch messages: \(error)")
                }
            } receiveValue: { fetchedMessages in
                // Update the messages array with the fetched messages
                self.messages = fetchedMessages
                print("Fetched messages count: \(self.messages.count)")
            }.store(in: &cancellables)
        

    }

    func sendMessage(_ content: String, imageURL: String?, audioURL: String?, to recipientId: String, in conversationId: String) {
        let timestamp = Timestamp(date: Date())
        let message = HashtagMessage(senderId: user?.uid ?? "", senderUsername: user?.displayName ?? "", content: content, timestamp: timestamp, imageURL: imageURL, audioURL: audioURL)
        
        // Add the message to the messages array before it is sent
        self.messages.append(message)
        print("Message added to array, array count: \(self.messages.count)")

        service.sendMessage(message, to: recipientId, in: conversationId).sink { completion in
            switch completion {
            case .finished:
                print("Message sent successfully")
            case .failure(let error):
                print("Failed to send message: \(error)")
            }
        } receiveValue: { _ in }.store(in: &cancellables)
    }

    
    
    
    func getConversationId(user1Id: String, user2Id: String) -> String {
            return service.getConversationId(user1Id: user1Id, user2Id: user2Id)
        }
    
    func fetchMessagesForUser(currentUserId: String, recipientId: String) {
           let conversationId = service.getConversationId(user1Id: currentUserId, user2Id: recipientId)
           fetchMessages(in: conversationId)
       }
}

