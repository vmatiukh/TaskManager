//
//  TaskListViewModel.swift
//  TaskManagerApp
//
//  Created by Volodymyr Matukh on 3/4/19.
//  Copyright © 2019 Vmatiukh. All rights reserved.
//

import Foundation
import CoreData

enum Ordering:String {
    case asc, desc
    static var items = ["asc", "desc"]
}
enum Sorting: String {
    case title, priority, date
    
    var item:String {
        switch self {
        case .title:
            return "Name"
        case .priority:
            return "Priority"
        case .date:
            return "Date"
        }
    }
    
    var localKey:String {
        switch self {
        case .priority:
            return "priorityKey"
        default:
            return self.rawValue
        }
    }
    static var elements = [Sorting.title, Sorting.priority, Sorting.date]
    static var items = [Sorting.title.item, Sorting.priority.item, Sorting.date.item]
}

class TaskListViewModel:NSObject {
    
    private var tastViewModelList = [TaskViewModel]()
    let tasksFetch:NSFetchRequest = Task.fetchRequest()
    lazy var fetchResultController: NSFetchedResultsController<Task> = {
        let fetchResultController = NSFetchedResultsController(fetchRequest: tasksFetch, managedObjectContext: DataManager.shared.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        return fetchResultController
    }()
    let taskManager = TaskManager()
    var editableTask:Task? {
        didSet {
            DataManager.shared.save()
        }
    }
    var creationTask:Task?
    var tasksCount: Int {
        return fetchResultController.fetchedObjects?.count ?? 0
    }
    
    var sorting:Sorting = .title {
        didSet {
            reloadData()
        }
    }
    var ordering:Ordering = .asc {
        didSet {
            reloadData()
        }
    }
    
    override init() {
        super.init()
        self.reloadData()
    }
    
    func reloadData() {
        tasksFetch.sortDescriptors = [NSSortDescriptor(key: sorting.localKey, ascending: ordering == .asc)]
        do {
            try fetchResultController.performFetch()
            if let contoller = fetchResultController as? NSFetchedResultsController<NSFetchRequestResult> {
                self.controllerDidChangeContent(contoller)
            }
        } catch {
            
        }
    }
    
    var contentUpdatedBlock:(()->())?
    
    func viewModel(at index:Int) -> TaskViewModel {
        return tastViewModelList[index]
    }
    
    func setEditableTask(at index:Int) {
        self.editableTask = fetchResultController.fetchedObjects?[index]
    }
    
    func createTaskIfNeed() {
        if editableTask == nil {
            creationTask = Task(context: DataManager.shared.managedContext)
        }
    }
}

// MARK: TASK UPDATING
extension TaskListViewModel {
    
    func updateTask(priority: Task.Priority) {
        guard let creationTask = creationTask else {
            editableTask?.priorityString = priority.rawValue
            return
        }
        creationTask.priorityString = priority.rawValue
    }
    
    func updateTask(title: String?) {
        guard let creationTask = creationTask else {
            editableTask?.title = title
            return
        }
        creationTask.title = title
    }
    
    func updateTask(dueDate: Date?) {
        guard let creationTask = creationTask else {
        editableTask?.date = dueDate as NSDate?
            return
        }
        creationTask.date = dueDate as NSDate?
    }
    
    func deleteEditableTask() {
        guard let editableTask = editableTask else {
            if let creationTask = creationTask {
                self.creationTask = nil
                DataManager.shared.delete(task: creationTask)
            }
            return
        }
        DataManager.shared.managedContext.refresh(editableTask, mergeChanges: false)
        self.editableTask = nil
        self.reloadData()
    }
}

// MARK: TasjManager
extension TaskListViewModel {
    func loadTasks(successBlock:SuccessBlock? = nil, errorBlock:@escaping ErrorBlock) {
        taskManager.loadTasks(page: 0, sorting: "\(sorting.rawValue) \(ordering.rawValue)", successBlock: { tasksList in
            tasksList.forEach({ dict in
                let _ = DataManager.shared.createOrLoadTask(dict: dict)
            })
            successBlock?()
        }, errorBlock: errorBlock)
    }
    
    
    func loadMoreTasks(successBlock:SuccessBlock? = nil, errorBlock:@escaping ErrorBlock) {
        taskManager.loadTasks(page: self.tasksCount/15, sorting: "\(sorting.rawValue) \(ordering.rawValue)", successBlock: { tasksList in
            tasksList.forEach({ dict in
                let _ = DataManager.shared.createOrLoadTask(dict: dict)
            })
            successBlock?()
        }, errorBlock: errorBlock)
    }
    
    func saveTask(successBlock:@escaping SuccessBlock, errorBlock:@escaping ErrorBlock) {
        guard let task = editableTask else {
            if let creationTask = creationTask {
                let encoder = JSONEncoder()
                let taskData = try! encoder.encode(creationTask)
                let taskDict = try! JSONSerialization.jsonObject(with: taskData, options: .allowFragments) as! [String: Any]
                taskManager.saveTask(params: taskDict, successBlock: { result in
                    DataManager.shared.delete(task: creationTask)
                    self.creationTask = nil
                    let _ = DataManager.shared.createOrLoadTask(dict: result)
                    successBlock()
                }, errorBlock: errorBlock)
            }
            return
        }
        let encoder = JSONEncoder()
        let taskData = try! encoder.encode(task)
        let taskDict = try! JSONSerialization.jsonObject(with: taskData, options: .allowFragments) as! [String: Any]
        taskManager.editTask(id: "\(task.id)", params: taskDict, successBlock: {
            self.editableTask = nil
            successBlock()
        } , errorBlock: errorBlock)
    }
    
    func removeTask(successBlock:@escaping SuccessBlock, errorBlock:@escaping ErrorBlock) {
        guard let task = editableTask else {
            return
        }
        taskManager.removeTask(id: "\(task.id)", successBlock: {
            self.editableTask = nil
            DataManager.shared.delete(task: task)
            successBlock()
        }, errorBlock: errorBlock)
    }

    
}

extension TaskListViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tastViewModelList.removeAll()
        self.fetchResultController.fetchedObjects?.forEach({ (task) in
            let taskModel = TaskViewModel(title: task.title ?? "", dueDate: task.date as Date?, priority: task.priority)
            tastViewModelList.append(taskModel)
        })
        self.contentUpdatedBlock?()
    }
}
