//
//  DocumentViewController.swift
//  Documents Core Data
//
//  Created by Danae N Nash on 9/30/19.
//  Copyright © 2019 Danae N Nash. All rights reserved.
//

import UIKit

class DocumentViewController: UIViewController {


    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var mainTextView: UITextView!
    
    var document: Document?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = ""
        if let document = document {
            let docTitle = document.docTitle
            titleTextField.text = docTitle
            mainTextView.text = document.mainText
            title = docTitle
            
        }
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func alertNotifyUser(message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        
        guard let name = titleTextField.text else {
            alertNotifyUser(message: "Document not saved.\nThe name is not accessable.")
            return
        }
        let documentName =  name.trimmingCharacters(in: .whitespaces)
        if (name == ""){
            alertNotifyUser(message: "Document not saved.\nA title is required")
            return
        }
        let content = mainTextView.text
        if document == nil {// document doesn't exist, create new one
            document = Document(docTitle: documentName, mainText: content)
        } else{// document exists, update existing one
            document?.update(docTitle: documentName, mainText: content)
        }
        
        if let document = document{
            do {
                let managedContext = document.managedObjectContext
                try managedContext?.save()
            } catch {
                alertNotifyUser(message: "The document countext could not be saved.")
            }
        } else {
            alertNotifyUser(message: "The document could not be created.")
        }
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func nameChanged(_ sender: Any) {
        title = titleTextField.text
    }
    // MARK: - Navigation

}
