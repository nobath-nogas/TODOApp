//
//  ViewController.swift
//  TODOApp
//
//  Created by Kaito on 2022/04/14.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return TodoContents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let TodoCell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        TodoCell.textLabel!.text = TodoContents[indexPath.row]
        return TodoCell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.object(forKey: "TodoList") != nil {
            TodoContents = UserDefaults.standard.object(forKey: "TodoList") as! [String]
        }
       
    }


}

