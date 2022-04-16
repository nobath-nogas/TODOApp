//
//  TodoModel.swift
//  TODOApp
//
//  Created by Kaito on 2022/04/16.
//

import Foundation
import RealmSwift

class TodoModel: Object{
    @objc dynamic var toDoId: Int = 0
    @objc dynamic var todoItems: String? = nil
    @objc dynamic var deadLineDate: String? = nil
}
