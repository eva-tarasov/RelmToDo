//
//  TaskList.swift
//  RelmToDo
//
//  Created by Евгений Тарасов on 18.08.2020.
//  Copyright © 2020 Евгений Тарасов. All rights reserved.
//

import RealmSwift

class TaskList: Object {
    @objc dynamic var name = ""
    @objc dynamic var date = Date()
    let tasks = List<Task>()
}
