//
//  TemplatesModel.swift
//  PhytoBast
//
//  Created by Роман Елфимов on 18.04.2022.
//

import Foundation
import RealmSwift

class TemplatesModel: Object {
    
    @objc dynamic var imageName: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var modelDescripiton: String = ""
    
    @objc dynamic var red: Int = 0
    @objc dynamic var green: Int = 0
    @objc dynamic var blue: Int = 0
    
    @objc dynamic var isFavourite: Bool = false
    @objc dynamic var stopTime: Int = 0
    
    @objc dynamic var createdAt: Date = Date()
    
    
    convenience init(imageName: String, title: String, modelDescripiton: String, red: Int, green: Int, blue: Int, isFavourite: Bool, stopTime: Int) {
        self.init()
        
        self.imageName = imageName
        self.title = title
        self.modelDescripiton = modelDescripiton
        self.red = red
        self.green = green
        self.blue = blue
        self.isFavourite = isFavourite
        self.stopTime = stopTime
    }
}
