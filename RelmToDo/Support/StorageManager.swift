//
//  StorageManager.swift
//  RelmToDo
//
//  Created by Евгений Тарасов on 18.08.2020.
//  Copyright © 2020 Евгений Тарасов. All rights reserved.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func saveTaskList(_ taskList: TaskList) {
        try! realm.write {
            realm.add(taskList)
        }
    }
    
    static func saveTask(_ task: Task, for taskList: TaskList) {
        try! realm.write{
            taskList.tasks.append(task)
        }
    }
    
    static func deleteTaskList(_ taskList: TaskList) {
        try! realm.write{
            // Удаление задач вложенных в список
            let tasks = taskList.tasks
            realm.delete(tasks)
            // удаление самого списка
            realm.delete(taskList)
        }
    }
    
    static func editTaskList(_ taskList: TaskList, with newListName: String) {
        try! realm.write{
            taskList.name = newListName
        }
    }
    
    static func makeAllDoneTask(_ taskList: TaskList) {
        try! realm.write{
            taskList.tasks.setValue(true, forKey: "isComplete")
        }
    }
    
    static func editTask(_ task: Task, with newName: String, and newNote: String) {
        try! realm.write{
            task.name = newName
            task.note = newNote
        }
    }
    
    static func deleteTask(_ task: Task) {
        try! realm.write{
            realm.delete(task)
        }
    }
    
    static func makeDone(_ task: Task) {
        try! realm.write{
            task.isComplete.toggle()
        }
    }
}
