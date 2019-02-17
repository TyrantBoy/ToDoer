//
//  CategoryViewController.swift
//  ToDoer
//
//  Created by Donald Nguyen on 2/16/19.
//  Copyright © 2019 Idunknow. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var category = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

       loadCategories()
    }
    
    
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "do it below", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Cat", style: .default) { (action) in
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.category.append(newCategory)
            self.saveCategories()
            
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add new category"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        tableCell.textLabel?.text = category[indexPath.row].name
        
        return tableCell
    }
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoViewController
        
        //curren row is selected
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = category[indexPath.row]
        }
    }
  
    
    //MARK: - Data Manipulation Methods
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("error \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories () {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
        category = try context.fetch(request)
        } catch {
            print("error loading catagories \(error)")
        }
        
        tableView.reloadData()
    }
   
}
