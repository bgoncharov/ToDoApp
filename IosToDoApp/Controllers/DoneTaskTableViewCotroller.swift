//
//  DoneTaskTableViewCotroller.swift
//  IosToDoApp
//
//  Created by Boris Goncharov on 11/8/20.
//

import UIKit

class DoneTaskTableViewCotroller: UITableViewController, Animatable {
    
    private let databasaManager = DatabaseManager()
    
    private var tasks: [Task] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listenToTasks()
    }
    
    
    private func listenToTasks() {
        databasaManager.addListener(forDoneTasks: true) { [weak self] (result) in
            switch result {
            
            case .success(let tasks):
                self?.tasks = tasks
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func handleActionButton(for task: Task) {
        guard let id = task.id else { return }
        
        databasaManager.updateTaskStatus(isDone: false, id: id) { [weak self] (result) in
            switch result {
            
            case .success():
                self?.showToast(state: .info, text: "Moved to Outgoing")
            case .failure(let error):
                self?.showToast(state: .info, text: error.localizedDescription)
            }
        }
    }
    
}


extension DoneTaskTableViewCotroller {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellid", for: indexPath) as! DoneTaskTableViewCell
        let task = tasks[indexPath.row]
        cell.configure(with: task)
        cell.actionButtonDidTap = {
            self.handleActionButton(for: task)
        }
        return cell
    }
    
}
