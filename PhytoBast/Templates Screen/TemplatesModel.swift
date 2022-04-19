//
//  TemplatesModel.swift
//  PhytoBast
//
//  Created by Роман Елфимов on 18.04.2022.
//

import Foundation

struct TemplatesModel: Hashable {
    let uid = UUID()
    
    let imageName: String = "АА"
    let title: String
    let description: String = ""
    
    let red: String = ""
    let green: String = ""
    let blue: String = ""
    
    let isFavourite: Bool = false
}
