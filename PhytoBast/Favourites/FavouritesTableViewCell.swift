//
//  FavouritesTableViewCell.swift
//  PhytoBast
//
//  Created by Роман Елфимов on 25.04.2022.
//

import UIKit

class FavouritesTableViewCell: UITableViewCell {
    
    // MARK: - Interface Properties
    
    private lazy var rgbPreView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        
        view.layer.cornerRadius = 5
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.3
    
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.clipsToBounds = false
        
        return view
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
