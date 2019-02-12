//
//  Item.swift
//  Todoey
//
//  Created by MATTEW MA on 3/2/19.
//  Copyright © 2019 Mathhew MA. All rights reserved.
//

// Replaced by Core Data entity

import Foundation
import RealmSwift
//
//class Item : Codable {
//    
//    var title : String
//    var isChecked : Bool
//    
//    init(content: String, whetherChecked: Bool) {
//        title = content
//        isChecked = whetherChecked
//    }
//    
//    
//}

class Item: Object {
    
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    @objc dynamic var dateCreated : Date?
}
