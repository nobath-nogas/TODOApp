//
//  AddController.swift
//  TODOApp
//
//  Created by Kaito on 2022/04/16.
//

import UIKit

var TodoContents = [String]()

class AddController: UIViewController {
    @IBOutlet weak var TodoTextField: UITextField!
    @IBAction func TodoAddButton(_ sender: Any) {
        TodoContents.append(TodoTextField.text!)
        TodoTextField.text = ""
        UserDefaults.standard.set( TodoContents, forKey: "TodoList" )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
