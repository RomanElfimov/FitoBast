//
//  DefaultTemplatesCell.swift
//  PhytoBast
//
//  Created by Роман Елфимов on 13.04.2022.
//

import UIKit

class DefaultTemplatesCell: UICollectionViewCell {
    
    var startButtonAction: (() -> ())?
    
    // MARK: - Reuse Id
    
    static let reuseId = "DefaultTemplatesCell"
    
    // MARK: - Interface Properties
    
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "PhotostockPlantIage")
        return iv
    }()
    
    // title
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.text = "Биколор"
        return label
    }()
    
    // description
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.3
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.text = "Подходит для рассады Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco l"
        return label
    }()
    
    
    
    // red
    private lazy var redLabel: UILabel = {
        let label = UILabel()
        label.text = "R: 255"
        return label
    }()
    
    // green
    private lazy var greenLabel: UILabel = {
        let label = UILabel()
        label.text = "G: 255"
        return label
    }()
    
    //blue
    private lazy var blueLabel: UILabel = {
        let label = UILabel()
        label.text = "B: 255"
        return label
    }()
    
    
    
    // start button
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.setTitle("Начать", for: .normal)
        button.backgroundColor = .purple
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // add to favourites button
    private lazy var addToFavouritesButton: UIButton = {
        let button = UIButton()
        button.setTitle("В избранное", for: .normal)
        button.backgroundColor = UIColor(named: "LightGreenColor")
        return button
    }()
    
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        
        
        // Interface elements
        
        addSubview(imageView)
        
        // title + description
        let infoStack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        infoStack.axis = .vertical
        infoStack.distribution = .fillProportionally
        infoStack.spacing = 4
        infoStack.backgroundColor = .clear
        
        addSubview(infoStack)
        
        // rgb
        let rgbStack = UIStackView(arrangedSubviews: [redLabel, greenLabel, blueLabel])
        rgbStack.axis = .horizontal
        rgbStack.distribution = .equalSpacing
        
        addSubview(rgbStack)
        
        
        // buttons
        startButton.layer.cornerRadius = 16
        addToFavouritesButton.layer.cornerRadius = 16
        
        let buttonsStack = UIStackView(arrangedSubviews: [startButton, addToFavouritesButton])
        buttonsStack.axis = .vertical
        buttonsStack.distribution = .fillEqually
        buttonsStack.spacing = 8
        
        addSubview(buttonsStack)
        
        
        
        // constraints
        
        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: rgbStack.topAnchor, right: infoStack.leftAnchor, paddingTop: 8, paddingLeft: 8, paddingRight: 12, width: 120, height: 200)
        
        infoStack.anchor(top: topAnchor, left: imageView.rightAnchor, bottom: rgbStack.topAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 12, paddingBottom: 8, paddingRight: 8)
        
        rgbStack.anchor(top: infoStack.bottomAnchor, left: leftAnchor, bottom: buttonsStack.topAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16, height: 50)
        
        buttonsStack.anchor(top: rgbStack.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 32, paddingBottom: 8, paddingRight: 32, height: 90)
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 5
        self.layer.shadowRadius = 9
        layer.shadowOpacity = 0.3
        // На сколько отдалится тень
        layer.shadowOffset = CGSize(width: 5, height: 5)
        self.clipsToBounds = false
        
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
    }
    
    
    
    // MARK: - Public Method
    
    func configure(with model: TemplatesModel) {
        
    }
    
    
    
    @objc func startButtonTapped() {
//        print(startButton.tag)
        startButtonAction?()
    }
}
