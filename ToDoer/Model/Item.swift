//
//  Item.swift
//  ToDoer
//
//  Created by Donald Nguyen on 2/16/19.
//  Copyright © 2019 Idunknow. All rights reserved.
//

import Foundation

class Item: Encodable, Decodable {
    var title : String = ""
    var done : Bool = false
}
