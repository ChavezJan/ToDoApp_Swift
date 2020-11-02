//
//  List+CoreDataProperties.swift
//  Todo List App
//
//  Created by Jorge Alejandro Chavez Nuñez on 01/11/20.
//
//

import Foundation
import CoreData


extension List {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<List> {
        return NSFetchRequest<List>(entityName: "List")
    }

    @NSManaged public var to_do: String?
    @NSManaged public var done: Bool
    @NSManaged public var date: Date?
    @NSManaged public var descript: String?

}

extension List : Identifiable {

}
