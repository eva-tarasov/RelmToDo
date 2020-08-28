//
//  TaskListViewController.swift
//  RelmToDo
//
//  Created by Евгений Тарасов on 18.08.2020.
//  Copyright © 2020 Евгений Тарасов. All rights reserved.
//

import UIKit
import RealmSwift

class TaskListViewController: UITableViewController {
    
    // MARK: - Public Properties
    var taskLists: Results<TaskList>!
    
    // MARK: Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        taskLists = realm.objects(TaskList.self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - IBActions
    @IBAction func addButtonPressed(_ sender: Any) {
        alertForAddAndUpdateList()
    }
    
    @IBAction func sortingList(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            taskLists = taskLists.sorted(byKeyPath: "name")
        } else {
            taskLists = taskLists.sorted(byKeyPath: "date", ascending: false)
        }
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return taskLists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskListCell", for: indexPath)
        
        let taskList = taskLists[indexPath.row]
        
        cell.configure(with: taskList)
        
        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let currentTaskList = taskLists[indexPath.row]
        
        let deleteAction = UITableViewRowAction(style: .default, title: "delete") { _, _ in
            StorageManager.deleteTaskList(currentTaskList)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "edit") { _, _ in
            self.alertForAddAndUpdateList(currentTaskList) {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        
        let doneAction = UITableViewRowAction(style: .normal, title: "done") { _, _ in
            StorageManager.makeAllDoneTask(currentTaskList)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        editAction.backgroundColor = .orange
        doneAction.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        
        return [deleteAction, editAction, doneAction]
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Получаем индекс ячейки (с проверкой)
        if let indexPath = tableView.indexPathForSelectedRow {
            let taskList = taskLists[indexPath.row]
            let tasksVC = segue.destination as! TasksViewController
            tasksVC.taskList = taskList
        }
    }

}

// MARK: - Private function
extension TaskListViewController {
    
    private func alertForAddAndUpdateList(_ taskList: TaskList? = nil,
                                          completion: (() -> Void)? = nil
    ) {
        var title = "New list"
        var doneButton = "Save"
        
        if taskList != nil {
            title = "Edited list"
            doneButton = "Update"
        }
        
        let alert = UIAlertController(title: title, message: "Please insert new value", preferredStyle: .alert)
        var alertTextField: UITextField!
        
        let saveAction = UIAlertAction(title: doneButton, style: .default) { _ in
            guard let text = alertTextField.text, !text.isEmpty else { return }
            
            if let taskList = taskList {
                StorageManager.editTaskList(taskList, with: text)
                completion?()
            } else {
                let taskList = TaskList()
                taskList.name = text
                StorageManager.saveTaskList(taskList)
                self.tableView.insertRows(at: [IndexPath(row: self.taskLists.count - 1, section: 0)], with: .automatic)
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField { textField in
            alertTextField = textField
            textField.placeholder = "List name"
            
            if let taskList = taskList {
                alertTextField.text = taskList.name
            }
        }
        
        present(alert, animated: true)
    }
}
