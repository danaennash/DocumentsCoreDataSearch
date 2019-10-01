//
//  Document+CoreDataClass.swift
//  Documents Core Data
//
//  Created by Danae N Nash on 9/30/19.
//  Copyright © 2019 Danae N Nash. All rights reserved.
//
//

import UIKit
import CoreData

@objc(Document)
public class Document: NSManagedObject {
    var modifiedDate: Date?{
        get{
            return rawDate as Date?
        }
        set{
            rawDate = newValue as NSDate?
        }
    }
    convenience init?(docTitle: String?, mainText: String?){
        let appDelegate = UIApplication.shared.delegate as? AppDelegate //UIKit is needed to access UIApplication
        guard let managedContext = appDelegate?.persistentContainer.viewContext, let docTitle = docTitle, docTitle != "" else {
            return nil
        }
        self.init(entity: Document.entity(), insertInto: managedContext)
        self.docTitle = docTitle
        self.mainText = mainText
        if let textSize = mainText?.count {
            self.textSize = Int64(textSize)
        }else  {
            self.textSize = 0
        }
        
        self.modifiedDate = Date(timeIntervalSinceNow: 0)

    }
    
    func update(docTitle: String, mainText: String?){
        self.docTitle = docTitle
        self.mainText = mainText
        if let size = mainText?.count {
            self.textSize = Int64(size)
        } else {
            self.textSize = 0
        }
        self.modifiedDate = Date(timeIntervalSinceNow: 0)
    }
}
