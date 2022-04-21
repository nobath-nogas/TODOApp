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
    var toolBar2:UIToolbar!
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // ②初期値をセット
        todoTextField.text = todoItem
        deadLineDate.text = deadLine
        createDatePicker()
    }
    func createDatePicker(){
        
        // DatePickerModeをDate(日付)に設定
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .wheels
        // DatePickerを日本語化
        datePicker.locale = NSLocale(localeIdentifier: "ja_JP") as Locale
        
        // textFieldのinputViewにdatepickerを設定
        deadLineDate.inputView = datePicker
        
        // UIToolbarを設定
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // Doneボタンを設定(押下時doneClickedが起動)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneClicked))
        
        // Doneボタンを追加
        toolbar.setItems([doneButton], animated: true)
        
        // FieldにToolbarを追加
        deadLineDate.inputAccessoryView = toolbar
    }
    
    @objc func doneClicked(){
        let dateFormatter = DateFormatter()
        
        // 持ってくるデータのフォーマットを設定
        dateFormatter.dateFormat  = "yyyy/MM/dd HH:mm";
        dateFormatter.locale    = NSLocale(localeIdentifier: "ja_JP") as Locale?
        
        // textFieldに選択した日付を代入
        deadLineDate.text = dateFormatter.string(from: datePicker.date)
        
        // キーボードを閉じる
        self.view.endEditing(true)
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
