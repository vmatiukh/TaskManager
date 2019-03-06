//
//  DetailedTaskViewController.swift
//  TaskManagerApp
//
//  Created by Volodymyr Matukh on 3/6/19.
//  Copyright © 2019 Vmatiukh. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

protocol DetailedTaskViewControllerDelegate: class {
    func needShowEditTaskViewController(taskListViewModel:TaskListViewModel)
    func needsDissmiss(_ viewController:UIViewController)
}
class DetailedTaskViewController: UIViewController, NVActivityIndicatorViewable {

    var taskViewModel:TaskListViewModel!
    weak var delegate: DetailedTaskViewControllerDelegate?
    @IBOutlet weak var titleValueLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var priorityButton: RoundedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Task details"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editAction))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (taskViewModel.editableTask == nil) {
            self.delegate?.needsDissmiss(self)
            return
        }
        self.titleValueLabel.text = taskViewModel.editableTask?.title
        self.dueDateLabel.text = (taskViewModel.editableTask?.date as Date?)?.fullDateString
        priorityButton.setTitle(taskViewModel.editableTask?.priority.title, for: .normal)
        switch taskViewModel.editableTask?.priority ?? .none {
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
    
    @objc private func editAction() {
        self.delegate?.needShowEditTaskViewController(taskListViewModel: taskViewModel)
    }
    
    @IBAction private func deleteEventAction(_ sender: RoundedButton) {
        taskViewModel.removeTask(successBlock: { [unowned self] in
            self.delegate?.needsDissmiss(self)
            }, errorBlock: { [unowned self] error in
                self.handleError(error: error)
        } )
    }
}
