//
//  ViewController.swift
//  ToDoer
//
//  Created by Donald Nguyen on 2/15/19.
//  Copyright © 2019 Idunknow. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoViewController: UITableViewController {

    var todoItems : Results<Item>?
    let realm = try! Realm()
    
    //nil until set with prepare() destionation
    var selectedCategory : Category? {
        //happens as soon as selectedCategory get set with a value
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    


    //MARK - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell" , for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
        tableCell.textLabel?.text = item.title
        tableCell.accessoryType = item.done ? .checkmark : .none
        
            
        } else {
            tableCell.textLabel?.text = "no item added"
        }
        
        return tableCell

        
    }

    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //  print(itemArray[indexPath.row])
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                   item.done = !item.done
                   // realm.delete(item)
                }
            } catch {
                print("error saving status \(error)")
            }
        }
        
        tableView.reloadData()

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDoEr Item", message: "Do it.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    currentCategory.items.append(newItem)
                }
                } catch {
                    print("error saving new item")
                }
            }
            
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (text) in
            text.placeholder = "Create new item"
            textField = text
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //set a default value inside parameter
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true )
        tableView.reloadData()
    }
    
    
   
}


//// MARK - Search bar methods
//extension ToDoViewController : UISearchBarDelegate {
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        // title of coredata CONTAINS the search
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        // NSSort
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        loadItems(with: request, predicate: predicate)
//    }
//
//    //only when it changes NOT when it begins at 0
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            loadItems()
//
//
//
//            //threads control (not really)
//            //it's just an attempt to clear keyboard
//            //use main threads for UI
//            DispatchQueue.main.async {
//                //go to the background before you were activated
//                searchBar.resignFirstResponder()
//
//            }
//
//
//
//
//
//        }
//    }
// }

