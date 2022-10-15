//
//  ViewController.swift
//  TestApp
//
//  Created by Kamil Caglar on 10/10/2022.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var people: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "The List"
        tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
      //1
      guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
          return
      }
      
      let managedContext =
        appDelegate.persistentContainer.viewContext
      
      //2
        
      let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "Person")
      
      //3
      do {
        people = try managedContext.fetch(fetchRequest)
      } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
      }
    }

    @IBAction func addName(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Name",
                                      message: "Add a new name",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) {
            [unowned self] action in
            guard let textField = alert.textFields?.first,
                  let nameToSave = textField.text else {
                return
            }
            self.save(name: nameToSave)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    func save(name: String) {
        
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        // 1
        let managedContext =
        appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
        NSEntityDescription.entity(forEntityName: "Person",
                                   in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        // 3
        person.setValue(name, forKeyPath: "name")
        
        // 4
        do {
            try managedContext.save()
            people.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
//    private func presentShareSheet() {
////        let myTextAtCurrentRow = people[IndexPat]
//
//        guard let image = UIImage(systemName: "bell"), let url = URL(string: "https://www.google.com/") else {
//            return
//        } // bell resmi paylasiyor row ile degistir
//        let shareSheetVC = UIActivityViewController(activityItems:[image, url], applicationActivities: nil)
//        present(shareSheetVC, animated: true)
//    }

    
}
// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return people.count
  }
    
  func tableView(_ tableView: UITableView,cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let person = people[indexPath.row]
      let selfSizingCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SelfSizingTableViewCell
      selfSizingCell.cellLabelText.text = person.value(forKeyPath: "name") as? String
      return selfSizingCell
  }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") {_, _, _ in
            print("Edit Button")
            // edit ekle get the codes in add 
        }
        editAction.backgroundColor = .systemTeal
        let share = UIContextualAction(style: .normal , title: "Share") {_, _, _ in
            
            let person = self.people[indexPath.row]
            let textToShare = person.value(forKey: "name") as? String
            guard let image = UIImage(systemName: "bell"), let url = URL(string: "https://www.google.com/") else {
                return
            } // bell resmi paylasiyor row ile degistir
            let shareSheetVC = UIActivityViewController(activityItems:[textToShare,image], applicationActivities: nil)
            self.present(shareSheetVC, animated: true)
        
            
            
        }
        share.backgroundColor = .systemIndigo
        let delete = UIContextualAction(style: .destructive, title: "Delete") {_, _, _ in
            guard let appDelegate =
                    UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            // 1
            let managedContext =
            appDelegate.persistentContainer.viewContext
            
            // Remove the people from the CoreData
            appDelegate.persistentContainer.viewContext.delete(self.people[indexPath.row])
            // Save Changes
            do {
                try managedContext.save()
                //self.people.remove(at: indexPath.row)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            // Remove row from TableView
            self.people.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
        // SWIPE TO LEFT CONFIGURATION
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [share, delete, editAction])
        return swipeConfiguration
    }

    
    
    
}



