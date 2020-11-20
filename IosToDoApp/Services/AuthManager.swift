//
//  AuthManager.swift
//  IosToDoApp
//
//  Created by Boris Goncharov on 11/19/20.
//

import Foundation
import FirebaseAuth

class AuthManager {
    
    private let auth = Auth.auth()
    
    func login(withEmail email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        auth.signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
