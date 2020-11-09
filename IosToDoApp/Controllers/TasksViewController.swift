//
//  ViewController.swift
//  IosToDoApp
//
//  Created by Boris Goncharov on 11/8/20.
//

import UIKit

class TasksViewController: UIViewController {

    @IBOutlet weak var menuSegmentedControl: UISegmentedControl!
    @IBOutlet weak var doneTasksContainerView: UIView!
    @IBOutlet weak var outgoingTasksContainerView: UIView!
    
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
    
    @IBAction func addNewTaskTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "showAddNewTask", sender: nil)
    }
}

