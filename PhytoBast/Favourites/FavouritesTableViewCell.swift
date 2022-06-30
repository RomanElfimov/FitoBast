//
//  FavouritesTableViewCell.swift
//  PhytoBast
//
//  Created by Роман Елфимов on 25.04.2022.
//

import UIKit

class FavouritesTableViewCell: UITableViewCell {
    
    // MARK: - Interface Properties
    
    // Pre-View
    private lazy var rgbPreView: UIView = {
        let view = UIView()
        
        view.layer.cornerRadius = 5
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.3
        
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.clipsToBounds = false
        
        return view
    }()
    
    // Title
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    // Duration
    private let durationLabel = UILabel()
    
    // RGB
    private let redLabel = UILabel()
    private let greenLabel = UILabel()
    private let blueLabel = UILabel()
    
    
    // MARK: - LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Adding subViews
        addSubview(rgbPreView)
        addSubview(titleLabel)
        addSubview(durationLabel)
        
        let rgbStack = UIStackView(arrangedSubviews: [redLabel, greenLabel, blueLabel])
        rgbStack.axis = .horizontal
        rgbStack.distribution = .equalSpacing
        
        addSubview(rgbStack)
        
        // Setup constraints
        rgbPreView.anchor(top: topAnchor, left: leftAnchor, bottom: rgbStack.topAnchor, right: titleLabel.leftAnchor, paddingTop: 22, paddingLeft: 16, paddingBottom: 8, paddingRight: 16, width: 70)
        
        titleLabel.anchor(top: topAnchor, left: rgbPreView.rightAnchor, bottom: durationLabel.topAnchor, right: rightAnchor, paddingTop: 22, paddingLeft: 16, paddingBottom: 8, paddingRight: 16)
        
        durationLabel.anchor(top: titleLabel.bottomAnchor, left: rgbPreView.rightAnchor, bottom: rgbStack.topAnchor, right: rightAnchor, paddingTop: 12, paddingLeft: 16, paddingBottom: 8, paddingRight: 16)
        
        rgbStack.anchor(top: durationLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16, height: 50)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - Public Method
    
    public func configure(with model: TemplatesModel) {
        rgbPreView.backgroundColor = UIColor(red: CGFloat(model.red)/255, green: CGFloat(model.green)/255, blue: CGFloat(model.blue)/255, alpha: 1)
        titleLabel.text = model.title
        redLabel.text = "R: \(model.red)"
        greenLabel.text = "G: \(model.green)"
        blueLabel.text = "B: \(model.blue)"
        
        durationLabel.text = "Время: \(model.stopTime) ч."
    }
    
    
}
