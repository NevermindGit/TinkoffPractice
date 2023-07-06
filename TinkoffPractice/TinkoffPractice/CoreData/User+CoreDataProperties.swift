//
//  User+CoreDataProperties.swift
//  test
//
//  Created by Vadim Valeev on 02.07.2023.
//
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {}

extension User {

    @NSManaged public var id: Int16
    @NSManaged public var userInfo: String?
    @NSManaged public var login: String?
    @NSManaged public var password: String?

}

extension User: Identifiable {}
