//
//  EditController.swift
//  TODOApp
//
//  Created by Kaito on 2022/04/16.
//

import UIKit
import RealmSwift

class EditController: UIViewController {
    @IBOutlet weak var todoTextField: UITextField!
    @IBOutlet weak var deadLineDate: UITextField!
    
    // ①一覧画面から受け取るように変数を用意
    var toDoIdEdit: Int!
    var todoItem: String!
    var deadLine: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // ②初期値をセット
        
        todoTextField.text = todoItem
        deadLineDate.text = deadLine
    }
    @IBAction func tapEditButton(_ sender: UIButton) {
        // ① realmインスタンスの生成
        let realm = try! Realm()
        
        // ② 更新したいデータを検索する
        let targetToDo = realm.objects(TodoModel.self).filter("toDoId == %@", toDoIdEdit!).first
        try! realm.write{
            targetToDo?.todoItems = todoTextField.text
            targetToDo?.deadLineDate = deadLineDate.text
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func tapDeleteButton(_ sender: UIButton) {
        // ① realmインスタンスの生成
        let realm = try! Realm()
        
        // ② 更新したいデータを検索する
        guard let targetToDo = realm.objects(TodoModel.self).filter("toDoId == %@", toDoIdEdit!).first else {
            
            return
        }
        
        try! realm.write{
            realm.delete(targetToDo)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
