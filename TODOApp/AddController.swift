//
//  AddController.swift
//  TODOApp
//
//  Created by Kaito on 2022/04/16.
//

import UIKit
import RealmSwift

var TodoContents = [String]()

class AddController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var TodoTextField: UITextField!
    @IBOutlet weak var deadLineTextField: UITextField!
    
    var todoItems: Results<TodoModel>!
    
    override func viewDidLoad() {
            super.viewDidLoad()

            let realm_1 = try! Realm()
            
            self.todoItems = realm_1.objects(TodoModel.self)
        }
    //追加画面でTodoをRealmに登録する
    @IBAction func TodoAddButton(_ sender: Any) {
        
        let todoItem:TodoModel = TodoModel()
        todoItem.toDoId = createTodoId()
        todoItem.todoItems = self.TodoTextField.text
        todoItem.deadLineDate = self.deadLineTextField.text
        
        let realm_2 = try! Realm()
        
        try! realm_2.write{
            realm_2.add(todoItem)
        }
        
        TodoTextField.text = ""
        deadLineTextField.text = ""

    }
    //連番でIdを生成する
    func createTodoId() -> Int{
        let realm_3 = try! Realm()
        let toDoIdList = realm_3.objects(TodoModel.self).sorted(byKeyPath: "toDoId", ascending: false).first
        return toDoIdList?.value(forKey: "toDoId") as! Int + 1
    }

}
