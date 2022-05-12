//
//  TodoModel.swift
//  TODOApp
//
//  Created by Kaito on 2022/04/16.
//

import Foundation
import RealmSwift
//TODOモデルクラス
class TodoModel: Object{
    @objc dynamic var toDoId: Int = 0               //TODO識別ID
    @objc dynamic var todoItems: String? = nil      //TODO
    @objc dynamic var deadLineDate: String? = nil   //期限
}
