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
    private var listener: ListenerRegistration?
    
    private lazy var tasksCollection = db.collection("tasks")
    
    
    func addTask(_ task: Task, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            _ = try tasksCollection.addDocument(from: task, completion: { (error) in
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
    
    func addListener(completion: @escaping (Result<[Task], Error>) -> Void) {
        
        listener = tasksCollection.addSnapshotListener({ (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                
//                var tempTasks = [Task]()
                
//                snapshot?.documents.forEach({ (document) in
//                    if let task = try? document.data(as: Task.self) {
//                        tempTasks.append(task)
//                    }
//                })
                
                let tempTasks = try? snapshot?.documents.compactMap({
                    return try $0.data(as: Task.self)
                })
                
                let tasks = tempTasks ?? []
                
                completion(.success(tasks))
            }
        })
    }
    
    func updateTaskToDone(id: String, completion: (Result<Void, Error>) -> Void) {
        
    }
    
}
