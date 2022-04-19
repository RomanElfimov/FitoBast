//
//  TemplatesHeader.swift
//  PhytoBast
//
//  Created by Роман Елфимов on 18.04.2022.
//

import UIKit

class TemplatesHeader: UICollectionReusableView {
    
    static let reuseId = "TemplatesHeader"
    
    private let title = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor)
        title.textColor = .label
        title.font = UIFont(name: "laoSangamMN", size: 20)
    }
    
    func configurate(text: String) {
        title.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
