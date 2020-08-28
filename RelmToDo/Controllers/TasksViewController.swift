//
//  TasksViewController.swift
//  RelmToDo
//
//  Created by Евгений Тарасов on 18.08.2020.
//  Copyright © 2020 Евгений Тарасов. All rights reserved.
//

import UIKit
import RealmSwift

class TasksViewController: UITableViewController {
    
    // MARK: - Public Properties
    var taskList: TaskList!
    
    // MARK: - Private Properties
    private var currentTasks: Results<Task>!
    private var completedTask: Results<Task>!
    
    private var isEditingMode = false

    // MARK: Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = taskList.name
        filteringTasks()

    }
    
    // MARK: - IBActions
    @IBAction func addButtonTask(_ sender: Any) {
        alertForAddAndUpdateTask()
    }
    
    @IBAction func editButtonTask(_ sender: Any) {
        isEditingMode.toggle()
        tableView.setEditing(isEditingMode, animated: true)
    }
    

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return section == 0 ? currentTasks.count : completedTask.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Current tasks" : "Completed tasks"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TasksCell", for: indexPath)
        let task = indexPath.section == 0 ? currentTasks[indexPath.row] : completedTask[indexPath.row]
        
        cell.textLabel?.text = task.name
        cell.detailTextLabel?.text = task.note
        
        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let currentTask = indexPath.section == 0 ? currentTasks[indexPath.row] : completedTask[indexPath.row]
        
        let deleteAction = UITableViewRowAction(style: .default, title: "delete") { (_, _) in
            StorageManager.deleteTask(currentTask)
            self.filteringTasks()
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "edit") { (_, _) in
            self.alertForAddAndUpdateTask(currentTask)
            self.filteringTasks()
        }
        
        let doneAction = UITableViewRowAction(style: .normal, title: "done") { (_, _) in
            StorageManager.makeDone(currentTask)
            self.filteringTasks()
        }
        
        editAction.backgroundColor = .orange
        doneAction.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        
        return [editAction, doneAction, deleteAction]
    }

}

// MARK: - Private Properties

extension TasksViewController {
    
    private func filteringTasks() {
        currentTasks = taskList.tasks.filter("isComplete = false")
        completedTask = taskList.tasks.filter("isComplete = true")
        
        tableView.reloadData()
    }
    
    private func alertForAddAndUpdateTask(_ task: Task? = nil) {
        var title = "New task"
        var doneButton = "Save"
        
        if task != nil {
            title = "Edit task"
            doneButton = "Update"
        }
        
        let alert = UIAlertController(title: title, message: "Pleas insert new task", preferredStyle: .alert)
        
        var taskTextField: UITextField!
        var noteTextField: UITextField!
        
        let saveAction = UIAlertAction(title: doneButton, style: .default) { _ in
            guard let text = taskTextField.text, !text.isEmpty else { return }
            
            if let task = task {
                if let noteText = noteTextField.text, !noteText.isEmpty {
                    StorageManager.editTask(task, with: text, and: noteText)
                    self.tableView.reloadData()
                } else {
                    StorageManager.editTask(task, with: text, and: "")
                    self.tableView.reloadData()
                }
            } else {
                let task = Task()
                task.name = text
                
                if let noteText = noteTextField.text, !noteText.isEmpty {
                    task.note = noteText
                }
                
                StorageManager.saveTask(task, for: self.taskList)
                self.filteringTasks()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        alert.addTextField { taskText in
            taskTextField = taskText
            taskTextField.placeholder = "New Task"
            
            if let task = task {
                taskTextField.text = task.name
            }
        }
        
        alert.addTextField { noteText in
            noteTextField = noteText
            noteTextField.placeholder = "New note for task"
            
            if let task = task {
                noteTextField.text = task.note
            }
        }
        
        present(alert, animated: true)
    }
}
