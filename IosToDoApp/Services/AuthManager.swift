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
    
    func logout(completion: (Result<Void, Error>) -> Void) {
        do {
            try auth.signOut()
            completion(.success(()))
        } catch (let error) {
            completion(.failure(error))
        }
    }
    
    func isUserLogedIn() -> Bool {
        return auth.currentUser != nil
    }
    
    func getUserID() -> String? {
        return auth.currentUser?.uid
    }
}
