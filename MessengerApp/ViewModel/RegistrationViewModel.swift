//
//  RegistrationViewModel.swift
//  MessengerApp
//
//  Created by Admin on 02/09/22.
//

import Foundation

struct RegistrationViewModel {
    
    var email: String?
    var password: String?
    var fullname: String?
    var username: String?
    
    var isFormVailed: Bool {
        
        return email?.isEmpty == false && password?.isEmpty == false
                && fullname?.isEmpty == false && username?.isEmpty == false
    }
}
