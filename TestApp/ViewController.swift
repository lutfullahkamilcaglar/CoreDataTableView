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
            guard let textField = alert.textFields?.first, let nameToSave = textField.text else {
                return
            }
            self.save(nameValue: nameToSave)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    func save(nameValue: String) {
        
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        // 1
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // 2
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
        
    
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        
        // 3
        person.setValue(nameValue, forKeyPath: "name")
        
        // 4
        do {
            try managedContext.save()
            people.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func editName(editName: String, indexPath: IndexPath) {
        
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
        person.setValue(editName, forKeyPath: "name")
        // 4
        do {
            try managedContext.save()
            self.tableView?.reloadRows(at: [indexPath], with: .automatic)
           // self.tableView?.reloadRows(at: [indexPath], with: .automatic)
            //people.append(person)
            self.tableView.reloadData()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    // change the save method to editName remove people append everything would be good to go
    
}

//// MARK: - UITableViewDataSource
//extension ViewController: UITableViewDataSource {
//    
//  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    return people.count
//  }
//    
//  func tableView(_ tableView: UITableView,cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//      let person = people[indexPath.row]
//      let selfSizingCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SelfSizingTableViewCell
//      selfSizingCell.cellLabelText.text = person.value(forKeyPath: "name") as? String
//      return selfSizingCell
//  }
//    
//  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//    
//      let editAction = UIContextualAction(style: .normal, title: "Edit") {_, _, _ in
//        print("Edit Button")
//        
//        let person = self.people[indexPath.row]
//        var personMessage = person.value(forKey: "name") as? String
//        let alert = UIAlertController(title: "Edit Mode", message: personMessage, preferredStyle: .alert)
//        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
//            guard let textField = alert.textFields?.first else {
//                return
//            }
//            if let textToEdit = textField.text{
//                if textToEdit.count == 0{
//                    return
//                }
//                personMessage = textToEdit
//                //self.editName(editName: textToEdit, indexPath: indexPath)
//                //self.tableView.reloadData()
//                self.tableView?.reloadRows(at: [indexPath], with: .automatic)
//            } else {
//                return
//            }
//        }
//        
//        let cancelAction = UIAlertAction(title: "Cancel",
//                                            style: .cancel)
//        alert.addTextField()
//        guard let textField = alert.textFields?.first else{
//            return
//        }
//        textField.placeholder = "Change this message"
//        alert.addAction(saveAction)
//        alert.addAction(cancelAction)
//        self.present(alert, animated: true)
//    }
//    editAction.backgroundColor = .systemTeal
//    let share = UIContextualAction(style: .normal , title: "Share") {_, _, _ in
//        let person = self.people[indexPath.row]
//        let textToShare = person.value(forKey: "name") as? String
//        let shareSheetVC = UIActivityViewController(activityItems:[textToShare!], applicationActivities: nil)
//        self.present(shareSheetVC, animated: true)
//    }
//    share.backgroundColor = .systemIndigo
//    let delete = UIContextualAction(style: .destructive, title: "Delete") {_, _, _ in
//        guard let appDelegate =
//                UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//        
//        // 1
//        let managedContext =
//        appDelegate.persistentContainer.viewContext
//        
//        // Remove the people from the CoreData
//        appDelegate.persistentContainer.viewContext.delete(self.people[indexPath.row])
//        // Save Changes
//        do {
//            try managedContext.save()
//        } catch let error as NSError {
//            print("Could not save. \(error), \(error.userInfo)")
//        }
//        // Remove row from TableView
//        self.people.remove(at: indexPath.row)
//        self.tableView.reloadData()
//        
//    }
//    // SWIPE TO LEFT CONFIGURATION
//    let swipeConfiguration = UISwipeActionsConfiguration(actions: [share, delete, editAction])
//    return swipeConfiguration
//}
//
//    
//    
//    
//}



