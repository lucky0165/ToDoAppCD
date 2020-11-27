//
//  ViewController.swift
//  ToDoAppCD
//
//  Created by Łukasz Rajczewski on 21/11/2020.
//

import UIKit
import CoreData

class ViewController: UITableViewController {
    
    
    var contacts = [Contact]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        load()
    }
    
    func save() {
        do {
        try context.save()
        } catch {
            print("Error saving new contact: \(error)")
        }
        tableView.reloadData()
    }
    
    func load(with request: NSFetchRequest<Contact> = Contact.fetchRequest()) {
        do {
            contacts = try context.fetch(request)
        } catch {
            print("Error loading data: \(error)")
        }
        tableView.reloadData()
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        
        let alert = UIAlertController(title: "Add new contact", message: "", preferredStyle: .alert)
        alert.addTextField()
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { (saveAction) in
            
            let textField = alert.textFields![0]
            
            if let name = textField.text {
                let newContact = Contact(context: self.context)
                newContact.name = name
                newContact.done = false
                
                self.contacts.append(newContact)
            
                self.save()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    // MARK: - UITableView DataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let contact = contacts[indexPath.row]
        
        cell.textLabel?.text = contacts[indexPath.row].name
        
        // ternary operator ==> value = condition ? true : false
        cell.accessoryType = contact.done ? .checkmark : .none
        
        
        return cell
    }
    
    // MARK: - UITableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    //    let cell = tableView.cellForRow(at: indexPath)
     
        contacts[indexPath.row].done = !contacts[indexPath.row].done
        
        save()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UISwipeActionsConfiguration()
        
        // to delete ==>
        // context.delete(contacts[indexPath.row])
        // contacts.remove(at: indexPath.row)
        
        
        return action
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Contact> = Contact.fetchRequest()

        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
        
        let sort = NSSortDescriptor(key: "name", ascending: true)
        
        request.sortDescriptors = [sort]
        
        load(with: request)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            load()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
}

