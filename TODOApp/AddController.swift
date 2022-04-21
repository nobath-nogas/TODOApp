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
    @IBOutlet weak var deadLine: UITextField!
    let datePicker = UIDatePicker()
    var todoItems: Results<TodoModel>!
    var toolBar:UIToolbar!

    override func viewDidLoad() {
        super.viewDidLoad()
        let realm_1 = try! Realm()
        self.todoItems = realm_1.objects(TodoModel.self)
        createDatePicker()
    }
    func createDatePicker(){
        
        // DatePickerModeをDate(日付)に設定
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .wheels
        // DatePickerを日本語化
        datePicker.locale = NSLocale(localeIdentifier: "ja_JP") as Locale
        
        // textFieldのinputViewにdatepickerを設定
        deadLine.inputView = datePicker
        
        // UIToolbarを設定
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // Doneボタンを設定(押下時doneClickedが起動)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneClicked))
        
        // Doneボタンを追加
        toolbar.setItems([doneButton], animated: true)
        
        // FieldにToolbarを追加
        deadLine.inputAccessoryView = toolbar
    }
    
    @objc func doneClicked(){
        let dateFormatter = DateFormatter()
        
        // 持ってくるデータのフォーマットを設定
        dateFormatter.dateFormat  = "yyyy/MM/dd HH:mm";
        dateFormatter.locale    = NSLocale(localeIdentifier: "ja_JP") as Locale?
        
        // textFieldに選択した日付を代入
        deadLine.text = dateFormatter.string(from: datePicker.date)
        
        // キーボードを閉じる
        self.view.endEditing(true)
    }
    
    //追加画面でTodoをRealmに登録する
    @IBAction func TodoAddButton(_ sender: Any) {
        //アラートメッセージ設定用
        var alertMessage:String = ""
        
        //やること入力チェック
        if let toDoText = TodoTextField.text, !toDoText.isEmpty{
            // OK
        //nilまたは空文字の場合警告メッセージを設定する
        }else{
            alertMessage += "やることを入力してください。\n"
        }
        
        //期限入力チェック
        if let dateString = deadLine.text, !dateString.isEmpty{
            
            let dataFormatter = DateFormatter()
            dataFormatter.dateFormat = "yyyy/MM/dd HH:mm"
            
            if let date = dataFormatter.date(from: dateString) {
            // OK
                
            //yyyy/MM/dd HH:mmに変換できなかった場合警告
            } else {
                alertMessage += "yyyy/MM/dd HH:mmで入力してください。"
                
            }
        //nilまたは空文字の場合警告メッセージを設定する
        }else{
            alertMessage += "期限を入力してください。"
        }
        
        if alertMessage.isEmpty {
            //DB登録処理
            dbProcess()
        }else{
            let alert = UIAlertController(title: "エラー", message: alertMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func dbProcess(){
        
        let todoItem:TodoModel = TodoModel()
        todoItem.toDoId = createTodoId()
        todoItem.todoItems = self.TodoTextField.text
        todoItem.deadLineDate = self.deadLine.text
        
        let realm_2 = try! Realm()
        
        try! realm_2.write{
            realm_2.add(todoItem)
        }
        
        TodoTextField.text = ""
        deadLine.text = ""
        
    }
    //連番でIdを生成する
    func createTodoId() -> Int{
        //Id設定用
        var toDoId:Int = 0
        let realm_3 = try! Realm()
        let toDoIdList = realm_3.objects(TodoModel.self).sorted(byKeyPath: "toDoId", ascending: false).first
        if let tempToDoId = toDoIdList?.value(forKey: "toDoId") {
            toDoId = tempToDoId as! Int + 1
        }else{
            toDoId = 0
        }
        return toDoId
    }
    
}
