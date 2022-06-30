//
//  DefaultTemplatesCell.swift
//  PhytoBast
//
//  Created by Роман Елфимов on 13.04.2022.
//

import UIKit

class DefaultTemplatesCell: UICollectionViewCell {
    
    // MARK: - Completion Handlers
    
    var startButtonAction: (() -> ())? // Начать сценарий
    var favouritesButtonAction: (() -> ())? // Добавить/удалить в избранное
    
    // MARK: - Reuse Id
    
    static let reuseId = "DefaultTemplatesCell"
    
    // MARK: - Interface Properties
    
    // Template image
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "PhotostockPlantIage")
        return iv
    }()
    
    // Title
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    // Description
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    // RGB
    private let redLabel = UILabel()
    private let greenLabel = UILabel()
    private let blueLabel = UILabel()
    
    // Duration
    private let durationLabel = UILabel()
    
    // Start button
    private lazy var startButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setTitle("Начать", for: .normal)
        button.backgroundColor = .purple
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // Add to favourites
    lazy var favouritesButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setTitle("В избранное", for: .normal)
        button.backgroundColor = UIColor(named: "LightGreen")
        button.addTarget(self, action: #selector(favouritesButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        backgroundColor = UIColor.tertiarySystemGroupedBackground
        
        // Adding subviews
        
        // Title + Description
        let infoStack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        infoStack.axis = .vertical
        infoStack.distribution = .fillProportionally
        infoStack.spacing = 4
        infoStack.backgroundColor = .clear
        
        // RGB
        let rgbStack = UIStackView(arrangedSubviews: [redLabel, greenLabel, blueLabel])
        rgbStack.axis = .horizontal
        rgbStack.distribution = .equalSpacing
        
        // Buttons
        startButton.layer.cornerRadius = 16
        favouritesButton.layer.cornerRadius = 16
        
        let buttonsStack = UIStackView(arrangedSubviews: [startButton, favouritesButton])
        buttonsStack.axis = .vertical
        buttonsStack.distribution = .fillEqually
        buttonsStack.spacing = 8
        
        addSubview(imageView)
        addSubview(infoStack)
        addSubview(rgbStack)
        addSubview(durationLabel)
        addSubview(buttonsStack)
        
        
        // Setup constraints
        
        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: rgbStack.topAnchor, right: infoStack.leftAnchor, paddingTop: 8, paddingLeft: 8, paddingRight: 12, width: 120, height: 200)
        
        infoStack.anchor(top: topAnchor, left: imageView.rightAnchor, bottom: rgbStack.topAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 12, paddingRight: 8)
        
        rgbStack.anchor(top: infoStack.bottomAnchor, left: leftAnchor, bottom: durationLabel.topAnchor, right: rightAnchor, paddingLeft: 16, paddingRight: 16, height: 50)
        
        durationLabel.anchor(top: rgbStack.bottomAnchor, left: leftAnchor, bottom: buttonsStack.topAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 16, paddingBottom: 8, paddingRight: 16, height: 40)
        
        buttonsStack.anchor(top: durationLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 32, paddingBottom: 8, paddingRight: 32, height: 90)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Тени для ячейки
        self.layer.cornerRadius = 5
        self.layer.shadowRadius = 5
        layer.shadowOpacity = 0.3
        
        layer.shadowOffset = CGSize(width: 3, height: 5)
        self.clipsToBounds = false
        
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
    }
    
    
    
    // MARK: - Public Method
    
    // Настройка ячейки
    public func configure(with model: TemplatesModel) {
        imageView.image = UIImage(named: model.imageName)
        
        titleLabel.text = model.title
        descriptionLabel.text = model.modelDescripiton
        
        redLabel.text = "R: \(model.red)"
        greenLabel.text = "G: \(model.green)"
        blueLabel.text = "B: \(model.blue)"
        
        durationLabel.text = "Время: \(model.stopTime) ч."
        
        let titleForButton = model.isFavourite ? "Удалить из избранного" : "В избранное"
        favouritesButton.setTitle(titleForButton, for: .normal)
    }
    
    
    // MARK: - Selectors
    
    @objc func startButtonTapped() {
        startButtonAction?()
    }
    
    @objc func favouritesButtonTapped() {
        favouritesButtonAction?()
    }
}
