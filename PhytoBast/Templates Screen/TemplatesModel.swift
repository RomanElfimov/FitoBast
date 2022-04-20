//
//  TemplatesModel.swift
//  PhytoBast
//
//  Created by Роман Елфимов on 18.04.2022.
//

import Foundation

struct TemplatesModel: Hashable {
    let uid = UUID()
    
    let imageName: String
    let title: String
    let description: String
    
    let red: Int
    let green: Int
    let blue: Int
    
    let isFavourite: Bool = false
    var stopTimeIntMinutes: Int

}
