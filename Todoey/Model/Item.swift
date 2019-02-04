//
//  Item.swift
//  Todoey
//
//  Created by MATTEW MA on 3/2/19.
//  Copyright © 2019 Mathhew MA. All rights reserved.
//

import Foundation

class Item : Codable {
    
    var title : String
    var isChecked : Bool
    
    init(content: String, whetherChecked: Bool) {
        title = content
        isChecked = whetherChecked
    }
    
    
}
