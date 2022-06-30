//
//  ManualTemplatesCell.swift
//  PhytoBast
//
//  Created by Роман Елфимов on 13.04.2022.
//

import UIKit

class ManualTemplatesCell: UICollectionViewCell {
    
    // MARK: - Completion Handlers
    
    var startButtonAction: (() -> ())? // Начать сценарий
    var favouritesButtonAction: (() -> ())? // Добавить/удалить в избранное
    var deleteButtonAction: (() -> () )? // Удалить шаблон
    
    // MARK: - Reuse Id
    
    static let reuseId = "ManualTemplatesCell"
    
    
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
    
    // Delete Button
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "trash.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.red), for: .normal)
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        return button
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
        
        // RGB
        let rgbStack = UIStackView(arrangedSubviews: [redLabel, greenLabel, blueLabel])
        rgbStack.axis = .horizontal
        rgbStack.distribution = .equalSpacing
        
        
        // Buttons Stack
        startButton.layer.cornerRadius = 16
        favouritesButton.layer.cornerRadius = 16
        
        let buttonsStack = UIStackView(arrangedSubviews: [startButton, favouritesButton])
        buttonsStack.axis = .vertical
        buttonsStack.distribution = .fillEqually
        buttonsStack.spacing = 8
        
        addSubview(rgbPreView)
        addSubview(titleLabel)
        addSubview(durationLabel)
        addSubview(deleteButton)
        addSubview(rgbStack)
        addSubview(buttonsStack)
        
        
        // Setup constraints
        
        rgbPreView.anchor(top: topAnchor, left: leftAnchor, bottom: rgbStack.topAnchor, right: titleLabel.leftAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 8, paddingRight: 16, width: 70)
        
        titleLabel.anchor(top: topAnchor, left: rgbPreView.rightAnchor, bottom: durationLabel.topAnchor, right: deleteButton.leftAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 8, paddingRight: 16)
        
        deleteButton.anchor(top: topAnchor, left: titleLabel.rightAnchor, right: rightAnchor, paddingTop: 8, paddingRight: 8, width: 50, height: 50)
        
        durationLabel.anchor(top: titleLabel.bottomAnchor, left: rgbPreView.rightAnchor, bottom: rgbStack.topAnchor, right: rightAnchor, paddingTop: 12, paddingLeft: 16, paddingBottom: 8, paddingRight: 16)
        
        rgbStack.anchor(top: durationLabel.bottomAnchor, left: leftAnchor, bottom: startButton.topAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16, height: 50)
        
        buttonsStack.anchor(top: rgbStack.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 32, paddingBottom: 16, paddingRight: 32, height: 88)
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
    }
    
    
    // MARK: - Public Method
    
    // Настройка ячейки
    func configure(with model: TemplatesModel) {
        rgbPreView.backgroundColor = UIColor(red: CGFloat(model.red)/255, green: CGFloat(model.green)/255, blue: CGFloat(model.blue)/255, alpha: 1)
        titleLabel.text = model.title
        redLabel.text = "R: \(model.red)"
        greenLabel.text = "G: \(model.green)"
        blueLabel.text = "B: \(model.blue)"
        
        durationLabel.text = "Время: \(model.stopTime) ч."
        
        let titleForButton = model.isFavourite ? "Удалить из избранного" : "В избранное"
        favouritesButton.setTitle(titleForButton, for: .normal)
    }
    
    
    
    // MARK: - Selectors
    
    @objc func deleteButtonTapped() {
        deleteButtonAction?()
    }
    
    @objc func startButtonTapped() {
        startButtonAction?()
    }
    
    @objc func favouritesButtonTapped() {
        favouritesButtonAction?()
    }
}
