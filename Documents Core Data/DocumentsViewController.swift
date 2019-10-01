//
//  DocumentsViewController.swift
//  Documents Core Data
//
//  Created by Danae N Nash on 9/30/19.
//  Copyright © 2019 Danae N Nash. All rights reserved.
//

import UIKit
import CoreData

class DocumentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    let dateFormatter = DateFormatter()
    var documents = [Document]()
    var documentTitle = ""
    var documentText = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Documents"

        dateFormatter.timeStyle = .medium
        dateFormatter.dateStyle = .medium
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchDocuments()
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        fetchDocuments(searchText: searchText)
        tableView.reloadData()
    }
    
    func alertNotifyUser(message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel) {(alertAction)-> Void in
            print ("Ok selected")
            
        })
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func fetchDocuments(searchText: String? = nil){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Document> = Document.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "docTitle", ascending: true)]// order results by docTitle ascending
        if let query = searchText {
            fetchRequest.predicate = NSPredicate(format: "docTitle CONTAINS %@ OR mainText CONTAINS %@", query, query)
        }
        do {
            documents = try managedContext.fetch(fetchRequest)
        } catch{
            alertNotifyUser(message: "Fetch for documents could not be performed")
            return
        }
    }
    
    func deleteDocument(at indexPath: IndexPath)
    {
        let document = documents[indexPath.row]
        
        if let managedObjectContext = document.managedObjectContext {
            managedObjectContext.delete(document)
            do {
                try managedObjectContext.save()
                self.documents.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            } catch {
                alertNotifyUser(message: "Delete failed")
                tableView.reloadData()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "documentCell", for: indexPath)
        if let cell = cell as? DocumentTableViewCell{
            let document = documents[indexPath.row]
            cell.nameLabel.text = document.docTitle
            cell.sizeLabel.text = String(document.textSize) + " bytes"
            if let modifiedDate = document.modifiedDate {
                cell.modifiedLabel.text = dateFormatter.string(from: modifiedDate)
            } else {
                cell.modifiedLabel.text = "unknown"
            }
        }
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()// dispose of any resources that can be recreated
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DocumentViewController,
            let segueIdentifier = segue.identifier, segueIdentifier == "Editor",
            let row = tableView.indexPathForSelectedRow?.row{
                destination.document = documents[row]
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            deleteDocument(at: indexPath)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "Editor", sender: self)
        
    }

}
