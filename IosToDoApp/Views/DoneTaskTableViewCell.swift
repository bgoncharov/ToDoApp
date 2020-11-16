//
//  DoneTaskTableViewCell.swift
//  IosToDoApp
//
//  Created by Boris Goncharov on 11/16/20.
//

import UIKit

class DoneTaskTableViewCell: UITableViewCell {
   
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(with task: Task) {
        titleLabel.text = task.title
    }
}
