//
//  EditTaskViewController.swift
//  TaskManagerApp
//
//  Created by Volodymyr Matukh on 3/6/19.
//  Copyright © 2019 Vmatiukh. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

protocol EditTaskViewControllerDelegate: class {
    func needsDissmiss(_ viewController:UIViewController)
}

class EditTaskViewController: UIViewController, NVActivityIndicatorViewable {
    
    var taskViewModel:TaskListViewModel!
    @IBOutlet weak var titleTextView: RoundedTextView!
    @IBOutlet weak var titleTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var dueDateTextField: RoundedTextField!
    @IBOutlet var priorityButtons: [RoundedButton]!
    @IBOutlet weak var deleteButton: UIButton!
    
    weak var delegate: EditTaskViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskViewModel.createTaskIfNeed()
        
        self.deleteButton.isHidden = self.taskViewModel.creationTask != nil
        
        self.titleTextView.text = taskViewModel.editableTask?.title
        self.dueDateTextField.text = (taskViewModel.editableTask?.date as Date?)?.fullDateString
        self.showDatePicker(date:(taskViewModel.editableTask?.date as Date?))
        switch taskViewModel.editableTask?.priority ?? .none {
        case .low:
            self.lowPriorityAction(priorityButtons[2])
            break
        case .medium:
            self.mediumPriorityAction(priorityButtons[1])
            break
        case .high:
            self.highPriorityAction(priorityButtons[0])
            break
        default:
            break
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveAction))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(backAction))
        self.titleTextView.delegate = self
        self.dueDateTextField.delegate = self
        self.addHideKeyboardAction()
    }
    
    @objc private  func backAction() {
        taskViewModel.deleteEditableTask()
        self.delegate?.needsDissmiss(self)
    }
        
    @objc private func saveAction() {
        startAnimating()
        taskViewModel.saveTask(successBlock: { [unowned self] in
            self.stopAnimating()
            self.delegate?.needsDissmiss(self)
        }) { [unowned self] error in
            self.stopAnimating()
            self.handleError(error: error)
        }
    }
    
    @IBAction private func deleteEventAction(_ sender: RoundedButton) {
        taskViewModel.removeTask(successBlock: { [unowned self] in
            self.delegate?.needsDissmiss(self)
            }, errorBlock: { [unowned self] error in
                self.handleError(error: error)
        } )
    }
}

// MARK: TextViewDelegate
extension EditTaskViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let minimumTextViewHeight:CGFloat = 35
        if textView.contentSize.height > self.titleTextViewHeight.constant && textView.contentSize.height < 300 {
            self.titleTextViewHeight.constant = textView.contentSize.height
            textView.scrollRangeToVisible(NSMakeRange(0, 1))
        } else {
            if textView.contentSize.height < self.titleTextViewHeight.constant && textView.contentSize.height > minimumTextViewHeight {
                self.titleTextViewHeight.constant = textView.contentSize.height
            }
            if textView.contentSize.height < minimumTextViewHeight {
                self.titleTextViewHeight.constant = minimumTextViewHeight
            }
        }
        taskViewModel.updateTask(title: textView.text)
    }
}

// MARK: TextField Editing Methods
extension EditTaskViewController: UITextFieldDelegate {
    private func showDatePicker(date:Date?) {
        let datePicker = UIDatePicker()
        datePicker.date = date ?? Date()
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(datePickerChangeValueAction(_:)), for: .valueChanged)
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        toolbar.tintColor = UIColor.darkGray
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(datePickerDoneAction))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([spaceButton,doneButton], animated: false)
        
        dueDateTextField.inputAccessoryView = toolbar
        dueDateTextField.inputView = datePicker
    }
    
    @objc private func datePickerChangeValueAction(_ sender:UIDatePicker) {
        taskViewModel.updateTask(dueDate: sender.date)
        dueDateTextField.text = sender.date.fullDateString
    }
    
    @objc private func datePickerDoneAction() {
        dueDateTextField.endEditing(true)
    }
}

// MARK: Priority Actions
extension EditTaskViewController {
    private func updateButtons(_ sender: RoundedButton) {
        self.view.endEditing(true)
        priorityButtons.forEach { button in
            if button == sender {
                button.isSelected = true
            } else {
                button.isSelected = false
            }
        }
    }
    
    @IBAction private func highPriorityAction(_ sender: RoundedButton) {
        taskViewModel.updateTask(priority: .high)
        updateButtons(sender)
        sender.borderColor = UIColor.red
    }
    
    @IBAction private func mediumPriorityAction(_ sender: RoundedButton) {
        taskViewModel.updateTask(priority: .medium)
        updateButtons(sender)
        sender.borderColor = UIColor.orange
    }
    
    @IBAction private func lowPriorityAction(_ sender: RoundedButton) {
        taskViewModel.updateTask(priority: .low)
        updateButtons(sender)
        sender.borderColor = UIColor.green
    }
}

extension Date {
    var fullDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE dd MMM, YYYY"
        return dateFormatter.string(from: self)
    }
}
