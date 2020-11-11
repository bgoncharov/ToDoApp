//
//  DatabaseManager.swift
//  IosToDoApp
//
//  Created by Boris Goncharov on 11/10/20.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

class DatabaseManager {
    
    private var db = Firestore.firestore()
    
    private lazy var databaseCollection = db.collection("tasks")
    
    
    func addTask(_ task: Task, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            _ = try databaseCollection.addDocument(from: task, completion: { (error) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            })
        } catch (let error) {
            completion(.failure(error))
        }
    }
}
