//
//  ViewController.swift
//  ToDoAppCD
//
//  Created by Łukasz Rajczewski on 21/11/2020.
//

import UIKit

class ViewController: UITableViewController {
    
    
    var contacts = [String]()
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let contactsToLoad = userDefaults.array(forKey: "contacts") as? [String] {
            contacts = contactsToLoad
        }
        
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        
        let alert = UIAlertController(title: "Add new contact", message: "", preferredStyle: .alert)
        alert.addTextField()
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { (saveAction) in
            
            let textField = alert.textFields![0]
            
            if let newContact = textField.text {
                
                if newContact.count > 0 {
                    self.contacts.append(newContact)
                    
                    self.userDefaults.set(self.contacts, forKey: "contacts")
                    
                    self.tableView.reloadData()
                }
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
        
        cell.textLabel?.text = contacts[indexPath.row]
        
        return cell
    }
    
    // MARK: - UITableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    //    let cell = tableView.cellForRow(at: indexPath)
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    

    @IBAction func removeButtonPressed(_ sender: UIBarButtonItem) {
        
        userDefaults.removeObject(forKey: "contacts")
        contacts.removeAll()
        tableView.reloadData()
    }
    
    
}

