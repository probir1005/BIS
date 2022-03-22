//
//  User+CoreDataClass.swift
//  BIS
//
//  Created by TSSIOS on 04/08/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import CoreData
import Foundation

extension User {

    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<User> {
        let fr = NSFetchRequest<User>(entityName: "User")
        fr.sortDescriptors = [NSSortDescriptor(key: "firstName", ascending: true)]
        return fr
    }

    @NSManaged public var accessToken: String
    @NSManaged public var firstName: String
    @NSManaged public var lastName: String?
    @NSManaged public var reportsList: [String]?
    @NSManaged public var dashboardList: [String]?
}
