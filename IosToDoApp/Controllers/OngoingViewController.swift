//
//  OutgoingViewController.swift
//  IosToDoApp
//
//  Created by Boris Goncharov on 11/8/20.
//

import UIKit

class OngoingViewController: UITableViewController, Animatable {
    
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
        databasaManager.addListener(forDoneTasks: false) { [weak self] (result) in
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
        databasaManager.updateTaskToDone(id: id) { (result) in
            switch result {
            
            case .success():
                self.showToast(state: .info, text: "Moved to Done")
            case .failure(let error):
                self.showToast(state: .info, text: error.localizedDescription)
            }
        }
    }
}

extension OngoingViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! OngoingTaskTableViewCell
        
        let task = tasks[indexPath.row]
        cell.configure(task: task)
        cell.actionButtonDidTap = { [weak self] in
            self?.handleActionButton(for: task)
        }
        return cell
    }

}
