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
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // 日付フォーマット
//        let date = Date()
//        let dateFormatter = DateFormatter()
//        dateFormatter.timeStyle = .medium
//        dateFormatter.dateStyle = .medium
//        dateFormatter.locale = Locale(identifier: "ja_JP")
//
//        // 現在時刻の1分後に設定
//        let date2 = Date(timeInterval: 60, since: date)
//        let targetDate = Calendar.current.dateComponents(
//            [.year, .month, .day, .hour, .minute],
//            from: date2)
//
//        let dateString = dateFormatter.string(from: date2)
//        print(dateString)
//
//        // トリガーの作成
//        let trigger = UNCalendarNotificationTrigger.init(dateMatching: targetDate, repeats: false)
//
//        // 通知コンテンツの作成
//        let content = UNMutableNotificationContent()
//        content.title = "Calendar Notification"
//        content.body = dateString
//        content.sound = UNNotificationSound.default
//
//        // 通知リクエストの作成
//        request = UNNotificationRequest.init(
//            identifier: "CalendarNotification",
//            content: content,
//            trigger: trigger)
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "通知のタイトル"
        notificationContent.subtitle = "通知のサブタイトル"
        notificationContent.body = "通知の本文"
        notificationContent.sound = .default
        notificationContent.badge = 1 //バッチをアプリアイコンにつける場合は必要。バッチの数字を指定。
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 300, repeats: false) //ここでtimeIntervalに秒数を指定
        let request = UNNotificationRequest(identifier: "notice id", content: notificationContent, trigger: notificationTrigger)
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request, withCompletionHandler: nil)
        notificationCenter.delegate = self
        
        // Realmのインスタンスを生成
        let realm_1 = try! Realm()
        
        // Realmのfunctionでデータを取得。functionを更に追加することで、フィルターもかけられる
        self.todoItems = realm_1.objects(TodoModel.self)
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
                   completionHandler([.alert, .badge,.sound])
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
