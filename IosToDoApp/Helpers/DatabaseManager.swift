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
    
    func deleteTask(id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        tasksCollection.document(id).delete { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func addListener(forDoneTasks isDone: Bool, completion: @escaping (Result<[Task], Error>) -> Void) {
        
        listener = tasksCollection
            .whereField("isDone", isEqualTo: isDone)
            .order(by: "createdAt", descending: true)
            .addSnapshotListener({ (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                var tasks = [Task]()
                do {
                    tasks = try snapshot?.documents.compactMap({
                        return try $0.data(as: Task.self)
                    }) ?? []
                } catch (let error) {
                    completion(.failure(error))
                }
                
                completion(.success(tasks))
            }
        })
    }
    
    func updateTaskStatus(isDone: Bool,  id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        var fields: [String : Any] = [:]
        if isDone {
            fields = ["isDone" : true, "dontAt" : Date()]
        } else {
            fields = ["isDone" : false, "dontAt" : FieldValue.delete()]
        }
        tasksCollection.document(id).updateData(fields) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
