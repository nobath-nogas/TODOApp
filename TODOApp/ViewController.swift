//
//  ViewController.swift
//  TODOApp
//
//  Created by Kaito on 2022/04/14.
//

import UIKit
import RealmSwift
import UserNotifications
import os

class ViewController: UIViewController,UITableViewDelegate,UNUserNotificationCenterDelegate {
    @IBOutlet weak var todoTable: UITableView!
    
    var todoItems: Results<TodoModel>!
    var request:UNNotificationRequest!
    var remindContentsList:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Realmのインスタンスを生成
        let realm_1 = try! Realm()
        //Realmから期限を抽出する
        let todoModels = realm_1.objects(TodoModel.self)
        
        //期限の時間の30分前にプッシュ通知する
        for toDoList in todoModels{
            let deadline = toDoList.deadLineDate
            //期限をdate型に変換する
            let dateFormatter = DateFormatter()
        
            // タイムゾーン設定（端末設定によらず、どこの地域の時間帯なのかを指定する）
            dateFormatter.timeZone = TimeZone(abbreviation: "JST")
            
            dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
            var convDeadline = dateFormatter.date(from: "9999/99/99 23:59")
            
            if let tempDeadline = deadline {
                convDeadline = dateFormatter.date(from: tempDeadline)
            }else{
                
            }
            
            // 通知日時を期限の30分前に設定する
            let date30 = Calendar.current.date(byAdding: .minute, value: -30, to: convDeadline!)
            
            //プッシュ通知の内容設定
            let notificationContent = UNMutableNotificationContent()
            notificationContent.title = "リマインダー"
            notificationContent.subtitle = "期限が30分以内のタスク"
            notificationContent.sound = .default
            notificationContent.badge = (todoModels.count) as NSNumber//バッチをアプリアイコンにつける場合は必要。バッチの数字を指定。期限が30分以内のタスクの数分だけ表示する
            notificationContent.body = toDoList.todoItems ?? ""
            let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date30!), repeats: false)
            print(notificationTrigger)
            let request = UNNotificationRequest(identifier: String(toDoList.toDoId), content: notificationContent, trigger: notificationTrigger)
            
            //プッシュ通知表示
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.add(request, withCompletionHandler: nil)
            notificationCenter.delegate = self
        }
        
        let realm_2 = try! Realm()
        // Realmのfunctionでデータを取得。functionを更に追加することで、フィルターもかけられる
        self.todoItems = realm_2.objects(TodoModel.self)
        
        todoTable.reloadData()
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        os_log("Notified")
        // アプリ起動時も通知を行う
        if #available(iOS 14.0, *) {
            completionHandler([.banner, .list,.badge, .sound])
        } else {
            completionHandler([.alert, .list,.badge,.sound])
        }
    }
    @IBAction func setButton(_ sender: Any) {
        os_log("setButton")
        //通知でつけたバッジを削除する
        UIApplication.shared.applicationIconBadgeNumber = 0
        // 通知リクエストの登録
        let center = UNUserNotificationCenter.current()
        center.add(request)
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
    //セルの編集許可
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    //スワイプしたセルを削除　※arrayNameは変数名に変更してください
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let realm = try! Realm()
            try! realm.write {
                realm.delete(todoItems[indexPath.row])
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            todoTable.reloadData()
        }
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
