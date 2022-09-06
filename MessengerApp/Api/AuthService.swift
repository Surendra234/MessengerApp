//
//  AuthService.swift
//  MessengerApp
//
//  Created by Admin on 02/09/22.
//

import Firebase
import UIKit

struct RegistrationCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

class AuthService {
    
    static let shared = AuthService()
    
    func logUserIn(withEmail email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> (Void)) {
        
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    
    func createUser(credentials: RegistrationCredentials, completion: ((Error?) -> Void)?) {
        guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.3) else { return}
        
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_images/\(filename)")
        
        ref.putData(imageData) { meta, err in
            if let err = err {
                print("DEBUG: Failed to upload image with error: \(err.localizedDescription)")
                return
            }
            
            ref.downloadURL { url, err in
                guard let profileImageUrl = url?.absoluteString else { return}
                
                Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { result, err in
                    if let err = err {
                        print("DEBUG: Failed to create user with error: \(err.localizedDescription)")
                        return
                    }
                    guard let uid = result?.user.uid else { return}
                    
                    let data = ["email": credentials.email, "fullname": credentials.fullname,
                                "profileImageUrl": profileImageUrl, "uid": uid,
                                "username": credentials.username] as [String: Any]
                    
                    Firestore.firestore().collection("users").document(uid).setData(data, completion: completion)
                }
            }
        }
    }
}
