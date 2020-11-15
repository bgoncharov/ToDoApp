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
    }
    
    @IBAction func actionButtonTapped(_ sender: UIButton) {
        actionButtonDidTap?()
    }
    
}
