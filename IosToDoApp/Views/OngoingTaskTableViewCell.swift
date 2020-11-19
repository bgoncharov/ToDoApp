//
//  OngoingTaskTableViewCell.swift
//  IosToDoApp
//
//  Created by Boris Goncharov on 11/12/20.
//

import UIKit

class OngoingTaskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var deadlineLabel: UILabel!
    
    var actionButtonDidTap: (() -> Void)?
    
    func configure(task: Task) {
        self.titleLabel.text = task.title
        self.deadlineLabel.text = task.deadline?.toRelativeString()
        
        if task.deadline?.isOverDue() == true {
            deadlineLabel.textColor = .red
            deadlineLabel.font = UIFont(name: "AvenirNext-Medium", size: 12)
        }
    }
    
    @IBAction func actionButtonTapped(_ sender: UIButton) {
        actionButtonDidTap?()
    }
    
}
