//
//  TaskListViewController.swift
//  TaskManagerApp
//
//  Created by Volodymyr Matukh on 3/4/19.
//  Copyright © 2019 Vmatiukh. All rights reserved.
//

import UIKit
import PullToRefreshKit
import RLBAlertsPickers

protocol TaskListViewControllerDelegate: class {
    func needShowAddTaskViewController(taskListViewModel:TaskListViewModel)
    func needShowDetailedTaskViewController(taskListViewModel:TaskListViewModel)
}

class TaskListViewController: UIViewController {
    
    @IBOutlet weak var addTaskButton: UIButton!
    @IBOutlet var tableView: UITableView!
    
    let taskListViewModel = TaskListViewModel()
    weak var delegate: TaskListViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Tasks"
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(notificationsAction))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sorting", style: .plain, target: self, action: #selector(sortingAction))
        taskListViewModel.contentUpdatedBlock = { [unowned self] in
            self.tableView.reloadData()
        }
        addTaskButton.layer.cornerRadius = addTaskButton.bounds.height/2
        taskListViewModel.loadTasks { [unowned self] error in
            self.handleError(error: error)
        }
        self.tableView.tableFooterView = UIView()
        
        self.tableView.configRefreshHeader(container: self) {
            [weak self] in
            self?.taskListViewModel.loadTasks(successBlock: {
                self?.tableView.switchRefreshHeader(to: .normal(.success, 0.2))
            }) { error in
                self?.tableView.switchRefreshHeader(to: .normal(.none, 0.2))
                self?.handleError(error: error)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        if self.taskListViewModel.tasksCount > 15 {
            self.tableView.configRefreshFooter(container: self) {
                [weak self] in
                self?.taskListViewModel.loadMoreTasks(successBlock: {
                    self?.tableView.switchRefreshFooter(to: .normal)
                }) { error in
                    self?.tableView.switchRefreshFooter(to: .normal)
                    self?.handleError(error: error)
                }
            }
        }
    }
    
    @objc private func notificationsAction() {
        
    }
    
    @objc private func sortingAction() {
        let alert = UIAlertController(style: .actionSheet, title: "Sorting settings", message: "")
        
        let options: [String] = Sorting.items
        let ordering: [String] = Ordering.items
        let pickerViewValues = [options, ordering]
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: Sorting.items.firstIndex(of: taskListViewModel.sorting.item) ?? 0)
        
        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { vc, picker, index, values in
            DispatchQueue.main.async { [weak self] in
                    if index.column == 0 {
                        self?.taskListViewModel.sorting = Sorting.elements[index.row]
                    }
                
                if index.column == 1 {
                    self?.taskListViewModel.ordering = index.row == 0 ? .asc : .desc
                }
            }
        }
        alert.addAction(title: "Done", style: .cancel)
        alert.show()
    }
    
    @IBAction private func addTaskAction(_ sender: Any) {
        self.delegate?.needShowAddTaskViewController(taskListViewModel: taskListViewModel)
    }
    
}

// MARK: TableViewDataSource
extension TaskListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.taskListViewModel.tasksCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:"taskCellIdentifier" , for: indexPath) as? TaskTableViewCell else {
            return UITableViewCell()
        }
        cell.cellModel = taskListViewModel.viewModel(at: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        taskListViewModel.setEditableTask(at: indexPath.row)
        self.delegate?.needShowDetailedTaskViewController(taskListViewModel: taskListViewModel)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

