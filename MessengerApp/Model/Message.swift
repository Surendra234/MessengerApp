//
//  Message.swift
//  MessengerApp
//
//  Created by Admin on 04/09/22.
//

import Firebase

struct Message {
    
    let text: String
    let toId: String
    let fromId: String
    let timeStamp: Timestamp!
    let isFromCurrentUser: Bool
    
    var user: User?
    
    init(dictionary: [String: Any]) {
        
        self.text = dictionary["text"] as? String ?? ""
        self.toId = dictionary["toId"] as? String ?? ""
        self.fromId = dictionary["fromId"] as? String ?? ""
        self.timeStamp = dictionary["timeStamp"] as? Timestamp ?? Timestamp(date: Date())
        
        self.isFromCurrentUser = fromId == Auth.auth().currentUser?.uid
    }
}

struct Conversation {
    let user: User
    let message: Message
}
