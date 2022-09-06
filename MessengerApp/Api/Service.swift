//
//  Service.swift
//  MessengerApp
//
//  Created by Admin on 03/09/22.
//

import Firebase

struct Service {
    
    static func fetchUser(completion: @escaping ([User]) -> Void) {
        var users = [User]()
        Firestore.firestore().collection("users").getDocuments { snapshot, err in
            
            snapshot?.documents.forEach({ document in
                
                let dictionary = document.data()
                let user = User(dictionary: dictionary)
                users.append(user)
                completion(users)
            })
        }
    }
    
    static func fetchuser(withUid uid: String, completion: @escaping (User) -> Void) {
        COLLECTION_USER.document(uid).getDocument { snapshot, err in
            guard let dictionary = snapshot?.data() else { return}
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    
    static func fetchConversattions(completion: @escaping ([Conversation]) -> Void) {
        var conversations = [Conversation]()
        guard let uid = Auth.auth().currentUser?.uid else { return}
   
        let query = COLLECTION_MESSAGES.document(uid).collection("recent-message").order(by: "timestamp")
        
        query.addSnapshotListener { snapshot, err in
    
            snapshot?.documentChanges.forEach({ change in
                
                let dictionary = change.document.data()
                let message = Message(dictionary: dictionary)
                
                self.fetchuser(withUid: message.toId) { user in
  
                    let conversation = Conversation(user: user, message: message)
                    conversations.append(conversation)
                    completion(conversations)
                }
            })
        }
    }
    
    static func fetchMessage(forUser user: User, completion: @escaping ([Message]) -> (Void)) {
        var message = [Message]()
        guard let currentUid = Auth.auth().currentUser?.uid else { return}
        
        let query = COLLECTION_MESSAGES.document(currentUid).collection(user.uid).order(by:"timestamp")
        
        query.addSnapshotListener { snapshot, err in
            snapshot?.documentChanges.forEach({ change in
                
                if change.type == .added {
                    let dictionary = change.document.data()
                    message.append(Message(dictionary: dictionary))
                    completion(message)
                }
            })
        }
    }
    
    static func uploadMessage(_ message: String, to user: User, completion:  ((Error?) -> Void)?) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return}
        
        let data = ["text": message, "fromId": currentUid, "toId": user.uid, "timestamp":          Timestamp(date: Date())] as [String: AnyObject]
        
        COLLECTION_MESSAGES.document(currentUid).collection(user.uid).addDocument(data: data) { _ in
            
            COLLECTION_MESSAGES.document(user.uid).collection(currentUid).addDocument(data: data, completion: completion)
            
            COLLECTION_MESSAGES.document(currentUid).collection("recent-message").document(user.uid).setData(data)
            
            COLLECTION_MESSAGES.document(user.uid).collection("recent-message").document(currentUid).setData(data)
        }
    }
}
