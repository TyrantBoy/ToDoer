//
//  Category.swift
//  ToDoer
//
//  Created by Donald Nguyen on 2/17/19.
//  Copyright © 2019 Idunknow. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    
    //inside each category is category
    let items = List<Item>()
}
