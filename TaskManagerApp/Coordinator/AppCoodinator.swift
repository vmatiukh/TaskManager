//
//  AppCoodinator.swift
//  TaskManagerApp
//
//  Created by Volodymyr Matukh on 3/5/19.
//  Copyright © 2019 Vmatiukh. All rights reserved.
//

import UIKit

class AppCoodinator: Coordinator {
    let window: UIWindow
    let rootViewController: UINavigationController
    
    init(window: UIWindow) {
        self.window = window
        rootViewController = UINavigationController()
        rootViewController.navigationBar.barTintColor = UIColor.ultraLightColor
        rootViewController.navigationBar.tintColor = UIColor.darkGray
        if AuthManager.isLogined {
            rootViewController.setNavigationBarHidden(false, animated: false)
            rootViewController.pushViewController(taskListViewController, animated: true)
        } else {
            rootViewController.setNavigationBarHidden(true, animated: false)
            rootViewController.pushViewController(authViewController, animated: true)
        }
    }
    
    func start() {
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
}

extension AppCoodinator {
    var authViewController: AuthViewController {
        let authStoryboard = UIStoryboard(name: "Auth", bundle: nil)
        let authViewController = authStoryboard.instantiateViewController(withIdentifier: "AuthViewController") as! AuthViewController
        authViewController.delegate = self
        return authViewController
    }
    
    var taskListViewController: TaskListViewController {
        let taskListStoryboard = UIStoryboard(name: "TaskList", bundle: nil)
        let taskListViewController = taskListStoryboard.instantiateViewController(withIdentifier: "TaskListViewController") as! TaskListViewController
        taskListViewController.delegate = self
        return taskListViewController
    }
    
    var detailedTaskViewController: DetailedTaskViewController {
        let detailedTaskStoryboard = UIStoryboard(name: "DetailedTask", bundle: nil)
        let detailedTaskViewController = detailedTaskStoryboard.instantiateViewController(withIdentifier: "DetailedTaskViewController") as! DetailedTaskViewController
//        detailedTaskViewController.delegate = self
        return detailedTaskViewController
    }
    
    var editTaskViewController: EditTaskViewController {
        let editTaskStoryboard = UIStoryboard(name: "EditTask", bundle: nil)
        let editTaskViewController = editTaskStoryboard.instantiateViewController(withIdentifier: "EditTaskViewController") as! EditTaskViewController
        //        detailedTaskViewController.delegate = self
        return editTaskViewController
    }
}

extension AppCoodinator: AuthViewControllerDelegate {
    func didLogin() {
        rootViewController.pushViewController(taskListViewController, animated: true)
        rootViewController.setNavigationBarHidden(false, animated: true)
    }
}

extension AppCoodinator: TaskListViewControllerDelegate {
    func needShowAddTaskViewController(taskListViewModel: TaskListViewModel) {
        let editTaskViewController = self.editTaskViewController
        editTaskViewController.taskViewModel = taskListViewModel
        editTaskViewController.delegate = self
        editTaskViewController.title = "Add task"
        rootViewController.pushViewController(editTaskViewController, animated: true)
    }
    
    func needShowDetailedTaskViewController(taskListViewModel: TaskListViewModel) {
        let detailedTaskViewController = self.detailedTaskViewController
        detailedTaskViewController.taskViewModel = taskListViewModel
        detailedTaskViewController.delegate = self
        rootViewController.pushViewController(detailedTaskViewController, animated: true)
    }
}

extension AppCoodinator: EditTaskViewControllerDelegate, DetailedTaskViewControllerDelegate {
    func needsDissmiss(_ viewController: UIViewController) {
        self.rootViewController.popViewController(animated: true)
    }
    
    func needShowEditTaskViewController(taskListViewModel: TaskListViewModel) {
        let editTaskViewController = self.editTaskViewController
        editTaskViewController.taskViewModel = taskListViewModel
        editTaskViewController.delegate = self
        editTaskViewController.title = "Edit task"
        rootViewController.pushViewController(editTaskViewController, animated: true)
    }
}
