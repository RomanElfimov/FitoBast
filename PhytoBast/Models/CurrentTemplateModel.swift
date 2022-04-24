//
//  CurrentTemplateModel.swift
//  PhytoBast
//
//  Created by Роман Елфимов on 24.04.2022.
//

import Foundation
import RealmSwift

class CurrentTemplateModel: Object {
    
    @objc dynamic var title: String = ""
    
    @objc dynamic var red: Int = 0
    @objc dynamic var green: Int = 0
    @objc dynamic var blue: Int = 0
    
    @objc dynamic var stopTime: Int = 0
    
    convenience init(title: String, red: Int, green: Int, blue: Int, stopTime: Int) {
        self.init()
        
        self.title = title
        self.red = red
        self.green = green
        self.blue = blue
        self.stopTime = stopTime
    }
}
