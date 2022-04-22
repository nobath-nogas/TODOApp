//
//  ViewController.swift
//  TODOApp
//
//  Created by Kaito on 2022/04/14.
//

import UIKit
import RealmSwift
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
        
        //期限の時間を現時刻の30分以内であるかをチェック
        for toDoList in todoModels{
            let deadline = toDoList.deadLineDate
            //期限をdate型に変換する
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
            var convDeadline = dateFormatter.date(from: "9999/99/99 23:59")
            
            if let tempDeadline = deadline {
                convDeadline = dateFormatter.date(from: tempDeadline)
            }else{
                
            }
            
            //現在時刻の設定
            let tempNowDate = dateFormatter.string(from: Date())
            let nowDate = dateFormatter.date(from: tempNowDate)
            
         
            if let deadlineDate = convDeadline {
                let elapsedTime = nowDate!.timeIntervalSince(deadlineDate)
                //期限が30分以内であればcontentsListに設定
                if elapsedTime <= 60000{
                    remindContentsList.append(toDoList.todoItems ?? "")
                    
                }
            }else{
                //何もしない
            }
            
        }
        //リマインドするTODOがあればプッシュ通知する
        if !remindContentsList.isEmpty {
            var contents:String = ""
            for i in remindContentsList {
                contents += i + "\n"
            }
            //プッシュ通知の内容設定
            let notificationContent = UNMutableNotificationContent()
            notificationContent.title = "リマインダー"
            notificationContent.subtitle = "期限が30分以内のタスク"
            notificationContent.sound = .default
            notificationContent.badge = (todoModels.count) as NSNumber//バッチをアプリアイコンにつける場合は必要。バッチの数字を指定。期限が30分以内のタスクの数分だけ表示する
            notificationContent.body = contents
            let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false) //ここでtimeIntervalに秒数を指定
            let request = UNNotificationRequest(identifier: "notice id", content: notificationContent, trigger: notificationTrigger)
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
