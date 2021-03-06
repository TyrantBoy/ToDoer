//
//  Item.swift
//  ToDoer
//
//  Created by Donald Nguyen on 2/17/19.
//  Copyright © 2019 Idunknow. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    
    //each item has a parent property
    //specify property name inverse relationship variable -> items
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
