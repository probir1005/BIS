//
//  User+CoreDataProperties.swift
//  BIS
//
//  Created by TSSIOS on 04/08/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import CoreData
import Foundation

@objc(User)
public class User: NSManagedObject {

    @objc
    private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    convenience init(dto: UserDTO, context: NSManagedObjectContext) {
        self.init(context: context)
        self.accessToken = dto.accessToken
        self.firstName = dto.firstName
        self.lastName = dto.lastName
        self.dashboardList = dto.dashboardList
        self.reportsList = dto.reportList
    }
}

extension User {

    @nonobjc
    public class func fetchRequest(for userName: String) -> NSFetchRequest<User> {
        let fr = NSFetchRequest<User>(entityName: "User")
        fr.predicate = NSPredicate(format: "firstName = %@", userName)
        return fr
    }

    public class func fetchRequestUser() -> NSFetchRequest<User> {
        let fr = NSFetchRequest<User>(entityName: "User")
        return fr
    }

    public class func deleteRequest(for firstName: String) -> NSBatchDeleteRequest {
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fr.predicate = NSPredicate(format: "firstName = %@", firstName)
        let bdr = NSBatchDeleteRequest(fetchRequest: fr)
        bdr.resultType = .resultTypeObjectIDs
        return bdr
    }
}
