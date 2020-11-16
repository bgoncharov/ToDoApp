//
//  Task.swift
//  IosToDoApp
//
//  Created by Boris Goncharov on 11/10/20.
//

import FirebaseFirestoreSwift

struct Task: Identifiable, Codable {
    @DocumentID var id: String?
    @ServerTimestamp var createdAt: Date?
    let title: String
    var isDone: Bool = false
    var doneAt: Date?
}
