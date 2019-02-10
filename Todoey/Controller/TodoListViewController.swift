//
//  ViewController.swift
//  Todoey
//
//  Created by MATTEW MA on 3/2/19.
//  Copyright © 2019 Mathhew MA. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var toDoListItemArray = [Item]()
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        Load data from user default
//        if let items = UserDefaults.standard.array(forKey: "toDoListItemArray") as? [Item]{
//            toDoListItemArray = items
//        }
    
    }
    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = toDoListItemArray[indexPath.row].title
        
        cell.accessoryType = toDoListItemArray[indexPath.row].done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return toDoListItemArray.count
    
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        toDoListItemArray[indexPath.row].done = !toDoListItemArray[indexPath.row].done
        
//        context.delete(toDoListItemArray[indexPath.row])
//
//        toDoListItemArray.remove(at: indexPath.row)
        
        saveItems()
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
         
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let itemToBeAdded = textField.text{
                let newItem = Item(context: self.context)
                newItem.title = itemToBeAdded
                newItem.done = false
                newItem.parentCategory = self.selectedCategory
                self.toDoListItemArray.append(newItem)
                self.saveItems()
                
//                This piece of code is effective while using encoder and UserDefault
//                self.toDoListItemArray.append(Item(content: itemToBeAdded, whetherChecked: false))
            }
//            save data to Userdefault
//            self.defaults.set(self.toDoListItemArray, forKey: "toDoListItemArray")
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK:  - Data manipulation Methods
    
    func saveItems() {
        do{
            try context.save()
        }catch{
            print("Error saving context \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil) {
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let addtionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addtionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        
        do{
            toDoListItemArray = try context.fetch(request)
        }catch{
            print("Error while fetching item data: \(error)")
        }
        
        tableView.reloadData()
        
    }
    
//    These two functions are effective while using encoder
    
//    func saveItems () {
//        let encoder = PropertyListEncoder()
//
//        do{
//            let data = try encoder.encode(toDoListItemArray)
//            try data.write(to: dataFilePath!)
//        }catch{
//            print("Error while encoding")
//        }
//    }
//
//    func loadItems() {
//        if let data = try? Data(contentsOf: dataFilePath!){
//            let decoder = PropertyListDecoder()
//            do{
//                toDoListItemArray = try decoder.decode([Item].self, from: data)
//            }catch{
//                print("Decode Error: \(error)")
//            }
//        }
//    }
//
    
}


//MARK: - search bar methods

extension TodoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let searchRequest : NSFetchRequest<Item> = Item.fetchRequest()
       
        let searchPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        searchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        print(searchRequest.predicate.debugDescription)
        
        loadItems(with: searchRequest, predicate: searchPredicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
