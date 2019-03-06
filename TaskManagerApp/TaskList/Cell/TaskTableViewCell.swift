//
//  TaskTableViewCell.swift
//  TaskManagerApp
//
//  Created by Volodymyr Matukh on 3/6/19.
//  Copyright © 2019 Vmatiukh. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dueDateValueLabel: UILabel!
    @IBOutlet private weak var priorityButton: RoundedButton!
    
    var cellModel:TaskViewModel? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        titleLabel.text = cellModel?.title
        dueDateValueLabel.text = cellModel?.dueDate?.simpleDateString
        priorityButton.setTitle(cellModel?.priority.title, for: .normal)
        switch cellModel?.priority ?? .none {
        case .high:
            priorityButton.borderColor = UIColor.red
            break
        case .medium:
            priorityButton.borderColor = UIColor.orange
            break
        case .low:
            priorityButton.borderColor = UIColor.green
            break
        default:
            break
        }
    }

}

extension Date {
    var simpleDateString:String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YY"
        return dateFormatter.string(from: self)
    }
}
