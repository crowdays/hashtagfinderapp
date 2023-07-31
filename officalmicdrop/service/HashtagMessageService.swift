//
//  HashtagMessageService.swift
//  officalmicdrop
//
//  Created by Leo Juarez on 6/22/23.
//




import Foundation
import Combine
import Firebase
import FirebaseFirestoreSwift

class HashtagMessageService {
    let db = Firestore.firestore()

    func fetchMessages(in conversationId: String) -> Future<[HashtagMessage], Error> {
        let messagesRef = db.collection("conversations").document(conversationId).collection("messages")
        return Future { promise in
            messagesRef.getDocuments { (querySnapshot, err) in
                if let err = err {
                    promise(.failure(err))
                } else {
                    var messages: [HashtagMessage] = []
                    for document in querySnapshot!.documents {
                        let result = Result<HashtagMessage?, Error> {
                            try document.data(as: HashtagMessage.self)
                        }
                        switch result {
                        case .success(let message):
                            if let message = message {
                                // A HashtagMessage value was successfully initialized from the DocumentSnapshot.
                                messages.append(message)
                            } else {
                                print("Document does not exist")
                            }
                        case .failure(let error):
                            // A HashtagMessage value could not be initialized from the DocumentSnapshot.
                            promise(.failure(error))
                        }
                    }
                    promise(.success(messages))
                }
            }
        }
    }

    
    func sendMessage(_ message: HashtagMessage, to recipientId: String, in conversationId: String) -> Future<Void, Error> {
        let conversationRef = db.collection("conversations").document(conversationId)
        let messagesRef = conversationRef.collection("messages")
        return Future { promise in
            do {
                _ = try messagesRef.addDocument(from: message)
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }
    }

    func getConversationId(user1Id: String, user2Id: String) -> String {
        if user1Id < user2Id {
            return user1Id + "_" + user2Id
        } else {
            return user2Id + "_" + user1Id
        }
    }
    
}



