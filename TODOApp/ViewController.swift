//
//  ViewController.swift
//  TODOApp
//
//  Created by Kaito on 2022/04/14.
//

import UIKit
import RealmSwift


class ViewController: UIViewController,UITableViewDelegate {
    @IBOutlet weak var todoTable: UITableView!
    
    var todoItems: Results<TodoModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Realmのインスタンスを生成
        let realm_1 = try! Realm()
        
        // Realmのfunctionでデータを取得。functionを更に追加することで、フィルターもかけられる
        self.todoItems = realm_1.objects(TodoModel.self)
        todoTable.reloadData()
        
    }
    
    // 画面遷移した際に、リロードして全てのリストを表示
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Realmのインスタンスを生成
        let realm_1 = try! Realm()
        
        // Realmのfunctionでデータを取得。functionを更に追加することで、フィルターもかけられる
        self.todoItems = realm_1.objects(TodoModel.self)
        
        todoTable.reloadData()
    }
    
}
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let todoCell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        let item:TodoModel = self.todoItems[(indexPath as NSIndexPath).row];
        todoCell.textLabel?.text = item.todoItems
        return todoCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard: UIStoryboard = self.storyboard!
        let next = storyboard.instantiateViewController(withIdentifier: "EditController") as! EditController
        next.toDoIdEdit = self.todoItems[indexPath.row].toDoId
        next.todoItem = self.todoItems[indexPath.row].todoItems
        next.deadLine = self.todoItems[indexPath.row].deadLineDate
        
        
        self.present(next, animated: true, completion: nil)
    }
}
