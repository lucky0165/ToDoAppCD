//
//  ViewController.swift
//  ToDoAppCD
//
//  Created by Łukasz Rajczewski on 21/11/2020.
//

import UIKit

class ViewController: UITableViewController {
    
    
    var contacts = [DataModel]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Contacts.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadContacts()
        
    }
    
    func saveContacts() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(contacts)
            try data.write(to: dataFilePath!)
        } catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    func loadContacts() {
        let decoder = PropertyListDecoder()
        
        do {
            if let data = try? Data(contentsOf: dataFilePath!) {
                contacts = try decoder.decode([DataModel].self, from: data)
            }
        } catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        
        let alert = UIAlertController(title: "Add new contact", message: "", preferredStyle: .alert)
        alert.addTextField()
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { (saveAction) in
            
            let textField = alert.textFields![0]
            
            if let newName = textField.text {
                
                let newContact = DataModel(name: newName, done: false)
                self.contacts.append(newContact)
                
                self.saveContacts()
                
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
        
        
        
        cell.textLabel?.text = contacts[indexPath.row].name
        
        // ternary operator
        // value = condition ? true : false
        
        cell.accessoryType = contacts[indexPath.row].done == true ? .checkmark : .none
        
        return cell
    }
    
    // MARK: - UITableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        contacts[indexPath.row].done = !contacts[indexPath.row].done
        saveContacts()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    
    @IBAction func removeButtonPressed(_ sender: UIBarButtonItem) {
        
        
        tableView.reloadData()
    }
    
    
}

