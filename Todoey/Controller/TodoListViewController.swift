//
//  ViewController.swift
//  Todoey
//
//  Created by MATTEW MA on 3/2/19.
//  Copyright © 2019 Mathhew MA. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var toDoListItemArray = [Item]()
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let items = UserDefaults.standard.array(forKey: "toDoListItemArray") as? [Item]{
            toDoListItemArray = items
        }
        let newItem1 = Item(content: "Find Mike", whetherChecked: true)
        toDoListItemArray.append(newItem1)
        
        let newItem2 = Item(content: "Catch Mike", whetherChecked: false)
        toDoListItemArray.append(newItem2)
        
        let newItem3 = Item(content: "Eat Mike", whetherChecked: false)
        toDoListItemArray.append(newItem3)
    }
    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = toDoListItemArray[indexPath.row].title
        
        cell.accessoryType = toDoListItemArray[indexPath.row].isChecked ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return toDoListItemArray.count
    
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        toDoListItemArray[indexPath.row].isChecked = !toDoListItemArray[indexPath.row].isChecked
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
         
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let itemToBeAdded = textField.text{
                self.toDoListItemArray.append(Item(content: itemToBeAdded, whetherChecked: false))
            }
            
            self.defaults.set(self.toDoListItemArray, forKey: "toDoListItemArray")
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    

}

