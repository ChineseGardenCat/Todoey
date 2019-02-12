//
//  Category.swift
//  Todoey
//
//  Created by MATTEW MA on 11/2/19.
//  Copyright © 2019 Mathhew MA. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    
    @objc dynamic var name : String = ""
    
    let items = List<Item>()
    
}
