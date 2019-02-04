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
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Load data from user default
//        if let items = UserDefaults.standard.array(forKey: "toDoListItemArray") as? [Item]{
//            toDoListItemArray = items
//        }
        
        loadItems()
    
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
        
        saveItems()
        
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
//            save data to Userdefault
//            self.defaults.set(self.toDoListItemArray, forKey: "toDoListItemArray")
            
            
            self.saveItems()
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK - Data manipulation Methods
    
    func saveItems () {
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(toDoListItemArray)
            try data.write(to: dataFilePath!)
        }catch{
            print("Error while encoding")
        }
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                toDoListItemArray = try decoder.decode([Item].self, from: data)
            }catch{
                print("Decode Error: \(error)")
            }
        }
    }
    

}

