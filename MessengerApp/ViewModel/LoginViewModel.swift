//
//  LoginViewModel.swift
//  MessengerApp
//
//  Created by Admin on 02/09/22.
//

import Foundation

struct LoginViewModel {
    
    var email: String?
    var password: String?
    
    var isFormVailed: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
    }
}
