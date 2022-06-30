//
//  SectionType.swift
//  PhytoBast
//
//  Created by Роман Елфимов on 30.06.2022.
//

import UIKit

// MARK: - Section Type Enum for TemplatesVC

enum SectionType: Int, CaseIterable {
    case defaultTemplates
    case manualTemplates
    
    func description() -> String {
        switch self {
        case .defaultTemplates:
            return "Стандартные шаблоны"
        case .manualTemplates:
            return "Мои шаблоны"
        }
    }
}
