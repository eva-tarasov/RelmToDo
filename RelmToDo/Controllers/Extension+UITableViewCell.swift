//
//  Extension+UITableViewCell.swift
//  RelmToDo
//
//  Created by Евгений Тарасов on 21.08.2020.
//  Copyright © 2020 Евгений Тарасов. All rights reserved.
//

import UIKit

extension UITableViewCell {
    func configure(with taskList: TaskList) {
        textLabel?.text = taskList.name
        
        let currentTask = taskList.tasks.filter("isComplete = false")
        let completedTask = taskList.tasks.filter("isComplete = true")
        
        if !currentTask.isEmpty {
            detailTextLabel?.text = "\(currentTask.count)"
            detailTextLabel?.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            detailTextLabel?.font = UIFont.systemFont(ofSize: 17)
        } else if !completedTask.isEmpty {
            detailTextLabel?.text = "✓"
            detailTextLabel?.textColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
            detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        } else {
            detailTextLabel?.text = "0"
            detailTextLabel?.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            detailTextLabel?.font = UIFont.systemFont(ofSize: 17)
        }
    }
}
