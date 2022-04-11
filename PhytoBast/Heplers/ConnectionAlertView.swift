//
//  ConnectionAlertView.swift
//  PhytoBast
//
//  Created by Роман Елфимов on 10.04.2022.
//

import UIKit
import Lottie

class ConnectionAlertView: UIView {
    
    // MARK: - Properties
    
    private lazy var visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let alertView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
    
    private let animationView = AnimationView(name: "ConnectionAlertAnimation")
    
    private lazy var firstDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Устройство не в сети"
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var secondDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Проверьте подключение устройства к сети и доступ к интернету"
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var thirdDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Это сообщение пропадет автоматически"
        return label
    }()
    
    
    
    // MARK: - Init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    
    // MARK: - Setup Interface Private Method
    
    private func setupView() {
        
        // blur view
        addSubview(visualEffectView)
        visualEffectView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        visualEffectView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        visualEffectView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        visualEffectView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        // alert view
        visualEffectView.contentView.addSubview(alertView)
        alertView.backgroundColor = .white
        alertView.layer.cornerRadius = 50
        
        alertView.center(inView: visualEffectView)
        alertView.setDimensions(width: 300, height: 400)
        
        alertView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        alertView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.alertView.alpha = 1
            self.alertView.transform = CGAffineTransform.identity
        }

        
        
        // animation view
        alertView.addSubview(animationView)
        animationView.contentMode = .scaleAspectFill
       
        animationView.play { (finished) in
            self.animationView.reloadImages()
        }
        
        
        
        let stack = UIStackView(arrangedSubviews: [firstDescriptionLabel, secondDescriptionLabel])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 4
        
        
        alertView.addSubview(stack)
        
        animationView.anchor(top: alertView.topAnchor, left: alertView.leftAnchor, bottom: stack.topAnchor, right: alertView.rightAnchor)
        animationView.setDimensions(width: 200, height: 250)
        
        stack.anchor(top: animationView.bottomAnchor, left: alertView.leftAnchor, bottom: alertView.bottomAnchor, right: alertView.rightAnchor, paddingLeft: 12, paddingBottom: 12, paddingRight: 18)
        
        
        
    }
}


