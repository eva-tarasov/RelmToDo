//
//  Task.swift
//  RelmToDo
//
//  Created by Евгений Тарасов on 18.08.2020.
//  Copyright © 2020 Евгений Тарасов. All rights reserved.
//

import RealmSwift

class Task: Object {
    @objc dynamic var name = ""
    @objc dynamic var note = ""
    @objc dynamic var date = Date()
    @objc dynamic var isComplete = false
}
