//
//  Document+CoreDataProperties.swift
//  Documents Core Data
//
//  Created by Danae N Nash on 9/30/19.
//  Copyright © 2019 Danae N Nash. All rights reserved.
//
//

import Foundation
import CoreData


extension Document {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Document> {
        return NSFetchRequest<Document>(entityName: "Document")
    }

    @NSManaged public var docTitle: String?
    @NSManaged public var textSize: Int64
    @NSManaged public var rawDate: NSDate?
    @NSManaged public var mainText: String?

}
