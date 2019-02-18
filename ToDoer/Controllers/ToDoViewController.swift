//
//  ViewController.swift
//  ToDoer
//
//  Created by Donald Nguyen on 2/15/19.
//  Copyright © 2019 Idunknow. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoViewController: SwipeTableTableViewController {

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
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        
            
        } else {
            cell.textLabel?.text = "no item added"
        }
        
        return cell

        
    }

    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //  print(itemArray[indexPath.row])
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                   item.done = !item.done
                    
                    //if I want to delete instead of toggle checkmark
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
                    newItem.dateCreated = Date()
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
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
               try realm.write {
                    realm.delete(item)
                }
            } catch {
                print("\n error deleting item \(error)")
            }
        }
        
        tableView.reloadData()
    }
   
}


//// MARK - Search bar methods
extension ToDoViewController : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
     todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }

    //only when it changes NOT when it begins at 0
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            //threads control (not really)
            //it's just an attempt to clear keyboard
            //use main threads for UI
            DispatchQueue.main.async {
                //go to the background before you were activated
                searchBar.resignFirstResponder()

            }
        }
    }
 }

