//
//  ViewController.swift
//  IosToDoApp
//
//  Created by Boris Goncharov on 11/8/20.
//

import UIKit

class TasksViewController: UIViewController, Animatable {

    @IBOutlet weak var menuSegmentedControl: UISegmentedControl!
    @IBOutlet weak var doneTasksContainerView: UIView!
    @IBOutlet weak var outgoingTasksContainerView: UIView!
    
    private let databaseManager = DatabaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSegmentControl()
    }
    
    private func setupSegmentControl() {
        menuSegmentedControl.removeAllSegments()
        
        MenuSection.allCases.enumerated().forEach { (index, section) in
            menuSegmentedControl.insertSegment(withTitle: section.rawValue, at: index, animated: false)
        }
        menuSegmentedControl.selectedSegmentIndex = 0
    }
    
    @IBAction func segmentedControlSwitched(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            segmentsSwitcher(for: .ongoing)
        case 1:
            segmentsSwitcher(for: .done)
        default: break
        }
    }
    
    private func segmentsSwitcher(for section: MenuSection) {
        switch section {
        
        case .ongoing:
            doneTasksContainerView.isHidden = true
            outgoingTasksContainerView.isHidden = false
        case .done:
            doneTasksContainerView.isHidden = false
            outgoingTasksContainerView.isHidden = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNewTask",
           let destination = segue.destination as? NewTaskViewController {
            destination.delegate = self
        } else if segue.identifier == "showOngoingTaks" {
            let destination = segue.destination as? OngoingViewController
            destination?.delegate = self
        } else if segue.identifier == "showEditTask",
                  let destination = segue.destination as? NewTaskViewController,
                  let taskToEdit = sender as? Task {
            destination.delegate = self
            destination.taskToEdit = taskToEdit
        }
    }
    
    private func deleteTask(id: String) {
        databaseManager.deleteTask(id: id) { [weak self] (result) in
            switch result {
            
            case .success():
                self?.showToast(state: .success, text: "Task succsessfully deleted")
            case .failure(let error):
                self?.showToast(state: .error, text: error.localizedDescription)
            }
        }
    }
    
    private func editTask(task: Task) {
        performSegue(withIdentifier: "showEditTask", sender: task)
    }
    
    @IBAction func addNewTaskTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "showNewTask", sender: nil)
    }
}

extension TasksViewController: OngoingTasksTVCDelegate {
    func showOptions(for task: Task) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [unowned self] _ in
            guard let id = task.id else { return }
            self.deleteTask(id: id)
            print("delete task: \(task.title)")
        }
        let editAction = UIAlertAction(title: "Edit", style: .default) { [unowned self] _ in
            self.editTask(task: task)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        alertController.addAction(editAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension TasksViewController: NewTaskVCDelegate {
    func didEditTask(_ task: Task) {
        
        presentedViewController?.dismiss(animated: true, completion: {
            guard let id = task.id else { return }
            self.databaseManager.editTask(id: id, title: task.title, deadline: task.deadline) { (result) in
                switch result {
                
                case .success():
                    self.showToast(state: .info, text: "Task successfully edited")
                case .failure(let error):
                    self.showToast(state: .error, text: error.localizedDescription)
                }
            }
        })
    }
    
    func didAddTask(_ task: Task) {
        
        presentedViewController?.dismiss(animated: true, completion: { [unowned self] in
            self.databaseManager.addTask(task) {  (result) in
                switch result {
                
                case .success():
                    self.showToast(state: .success, text: "New task added")
                case .failure(let error):
                    self.showToast(state: .error, text: error.localizedDescription)
                }
            }
        })
    }
}
