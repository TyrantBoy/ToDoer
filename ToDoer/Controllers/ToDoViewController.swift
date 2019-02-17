//
//  ViewController.swift
//  ToDoer
//
//  Created by Donald Nguyen on 2/15/19.
//  Copyright © 2019 Idunknow. All rights reserved.
//

import UIKit
import CoreData

class ToDoViewController: UITableViewController {

    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    
    //Add more plist for different categories
   // let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
    
    }

    //MARK - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell" , for: indexPath)
        
        let item = itemArray[indexPath.row]
        tableCell.textLabel?.text = item.title
        
        
        tableCell.accessoryType = item.done ? .checkmark : .none
        
        return tableCell
        
    }

    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //  print(itemArray[indexPath.row])
        
        
        //delete on click
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)

        
        //quick toggle
       itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveAction()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDoEr Item", message: "Do it.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            
            self.itemArray.append(newItem)
            
            self.saveAction()
          
            
        }
        
        alert.addTextField { (text) in
            text.placeholder = "Create new item"
            textField = text
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveAction() {
        
        do {
           try context.save()
        } catch {
            print("ERROR saving context \(error)")
        }
        
        self.tableView.reloadData()

    }
    
    //set a default value inside parameter
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest()) {
 
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("error \(error)")
        }
        
        tableView.reloadData()
    }
    
    
   
}


// MARK - Search bar methods
extension ToDoViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        // title of coredata CONTAINS the search
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        // NSSort
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request)
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

