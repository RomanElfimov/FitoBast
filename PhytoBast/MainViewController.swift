//
//  ViewController.swift
//  PhytoBast
//
//  Created by Роман Елфимов on 07.04.2022.
//

import UIKit
import CocoaMQTT
import Lottie

class MainViewController: UIViewController {
    
    // MARK: - Priavte Properties
    
    // mqtt
    private var mqtt: CocoaMQTT!
    private let statusTopic: String = "FFF3/685F7B00685F7B00/status/#" // Топик для статуса устройства
    private let messageTopic: String = "FFF3/685F7B00685F7B00/api/v1/led/all/[0,5]" // Топик для сообщений
    
    // menu
    private var home = CGAffineTransform()
    private var isMenuPresented = false
    private let menuDataSourceArray = ["", "Шаблоны", "Ручная настройка", "Избранное", "Журнал"] // Опции меню
    
    private var lampScript: String = ""
    
    // timer
    private var sceduleTimer: Timer!
    
    private var hours: Int = 0
    private var mins: Int = 0
    private var secs: Int = 0
    private var isTimerCounting: Bool = false
    
    private let userDefaults = UserDefaults.standard
    
    private let timerKey = "timerKey"
    private let isCountingKey = "timerCount"
    
    
    
    
    // MARK: - Interface Properties
    
    private var alertView = ConnectionAlertView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
    
    
    private var menuTableView: UITableView!
    
    private let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
    
    
    private lazy var menuButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "menuIcon"), for: .normal)
        button.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let logoAnimationView = AnimationView(name: "LogoAnimation")
    
    private lazy var logoLabel: UILabel = {
        let label = UILabel()
        label.text = "Fito Bast"
        label.textAlignment = .center
        label.textColor = UIColor(named: "LightGreenColor")
        label.font = UIFont(name: "Snell Roundhand Bold", size: 54)
        return label
    }()
    
    private lazy var favouritesButton: UIButton = {
        let button = UIButton()
        button.setTitle("Сценарий", for: .normal)
        button.backgroundColor = UIColor(named: "LightGreenColor")
        return button
    }()
    
    
    // script button
    private lazy var scriptLabel: UILabel = {
        let label = UILabel()
        label.text = "Мой сценарий 1"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.textColor = UIColor(named: "DarkGreenColor")
        return label
    }()
    
    
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "LightGreenColor")
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        button.setTitle("Старт", for: .normal)
        return button
    }()
    
   
    private lazy var stopButton: UIButton = {
        let button = UIButton()
//        button.backgroundColor = UIColor(named: "DarkGreenColor")
        button.layer.borderColor = UIColor(named: "DarkGreenColor")?.cgColor
        button.layer.borderWidth = 2
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        button.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
        button.setTitle("Стоп", for: .normal)
        button.setTitleColor(UIColor(named: "DarkGreenColor"), for: .normal)
        return button
    }()
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMQTT()
        setupUI()
        
        home = self.containerView.transform
        menuTableView.backgroundColor = UIColor(named: "DarkGreenColor")
        addSwipeGestures()
        

        
        
//        let defaults = UserDefaults.standard
//            let dictionary = defaults.dictionaryRepresentation()
//            dictionary.keys.forEach { key in
//                defaults.removeObject(forKey: key)
//            }
        
//        if isTimerCounting {
//            stopButton.isHidden = false
//        }
        
        
        
        
        guard let date = userDefaults.value(forKey: timerKey) as? Date else { return }
        isTimerCounting = userDefaults.bool(forKey: isCountingKey)
        
        didCreateEvent(targetDate: date)
        
        print(isTimerCounting)
        
    
        
        
        if isTimerCounting {
            stopButton.isHidden = false
            print("hee")
        } else {
            stopButton.isHidden = true
            print("dddd")
        }
        
        
        stopButton.isHidden = isTimerCounting ? false : true
        startButton.isEnabled = isTimerCounting ? false : true
        
    }
    
    
    // MARK: - Private Methods
    
    // Настройка MQTT
    private func setupMQTT() {
        let clientID: String = "PhytoBast"
        let host: String = "mqtt0.bast-dev.ru"
        let port: UInt16 = 1883
        
        mqtt = CocoaMQTT(clientID: clientID, host: host, port: port)
        
        mqtt.username = "admin"
        mqtt.password = "adminpsw"
        
        mqtt.keepAlive = 60
//                        mqtt.delegate = self
        mqtt.connect()
    }
    
    
    private func didCreateEvent(targetDate: Date) {

        let difference = floor(targetDate.timeIntervalSince(Date()))
        if difference > 0.0 {
            
            let computedHours: Int = Int(difference) / 3600
            let remainder: Int = Int(difference) - (computedHours * 3600)
            let minutes: Int = remainder / 60
            let seconds: Int = Int(difference) - (computedHours * 3600) - (minutes * 60)
       

            hours = computedHours
            mins = minutes
            secs = seconds

//            updateLabel()

            startTimer()
            
        }
        else {
            print("negative interval")
//            sceduleTimer.invalidate()
            startButton.isEnabled = true
            stopButton.isHidden = true
        }
    }
    
    private func startTimer() {
        sceduleTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [self] _ in
            if self.secs > 0 {
                self.secs = self.secs - 1
            }
            else if self.mins > 0 && self.secs == 0 {
                self.mins = self.mins - 1
                self.secs = 59
            }
            else if self.hours > 0 && self.mins == 0 && self.secs == 0 {
                self.hours = self.hours - 1
                self.mins = 59
                self.secs = 59
            }

            
            let timeString = makeTimeString(hour: self.hours, min: self.mins, sec: self.secs)
            
            startButton.setTitle(timeString, for: .normal)
            
//            self.updateLabel()
        })
    }

//    private func updateLabel() {
//        startButton.setTitle("\(hours):\(mins):\(secs)", for: .normal)
//    }
    
    
    
    
    
    private func makeTimeString(hour: Int, min: Int, sec: Int) -> String {
        var timeString = ""
        timeString += String(format: "%02d", -hour)
        timeString += ":"
        timeString += String(format: "%02d", -min)
        timeString += ":"
        timeString += String(format: "%02d", -sec)
        return timeString.replacingOccurrences(of: "-", with: "")
    }
    
    
    private func switchLamp(red: Int, green: Int, blue: Int) {
        let messageDictionary : [String: Any] = [ "red": red, "green": green, "blue": blue]
        let jsonData = try! JSONSerialization.data(withJSONObject: messageDictionary, options: [])
        let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)!
       
        let message = CocoaMQTTMessage(topic: messageTopic, string: jsonString)
        mqtt.publish(message)
        mqtt.didReceiveMessage = { mqtt, message, id in
            print("Message received in topic \(message.topic) with payload \(message.string!)")
        }
    }
    
    
    
    
   
    
    
    // MARK: - UI Setup
    
    // Настраиваем элементы интерфейса
    private func setupUI() {
        
        // menu table
        
        menuTableView = UITableView()
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        
        view.addSubview(menuTableView)
        menuTableView.frame = view.bounds
        
        menuTableView.separatorStyle = .none
        menuTableView.rowHeight = 90
        menuTableView.backgroundColor = .white
        
        
        // container view
        
        view.addSubview(containerView)
        containerView.frame = view.bounds
        containerView.backgroundColor = .white
        
        
        
        // menu button
        containerView.addSubview(menuButton)
        menuButton.setDimensions(width: 35, height: 35)
        menuButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 16, paddingLeft: 16)
        
        // animation logo image
        containerView.addSubview(logoAnimationView)
        
        // logo label
        containerView.addSubview(logoLabel)
        
        logoAnimationView.anchor(top: menuButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 185)
        logoAnimationView.play()
        
        logoLabel.anchor(top: logoAnimationView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: -24, height: 72)
        
        
        // favourites button
        containerView.addSubview(favouritesButton)
        favouritesButton.setDimensions(width: 120, height: 40)
        favouritesButton.layer.cornerRadius = 17
        favouritesButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingTop: 16, paddingRight: 16)
        
        
        // script label
        containerView.addSubview(scriptLabel)
        scriptLabel.centerX(inView: view)
        scriptLabel.anchor(top: logoLabel.bottomAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor,  paddingTop: 24, height: 50)
        
        
        // start button
        containerView.addSubview(startButton)
        containerView.addSubview(stopButton)
        
        startButton.centerX(inView: view)
        startButton.setDimensions(width: 200, height: 200)
        startButton.anchor(bottom: stopButton.topAnchor, paddingBottom: 32)
        startButton.layer.cornerRadius = 100
        
        // stop button
        
        stopButton.centerX(inView: view)
        stopButton.setDimensions(width: 200, height: 60)
        stopButton.anchor(bottom: view.bottomAnchor, paddingBottom: 70)
        stopButton.layer.cornerRadius = 16
        
        
    }
    
    
    // Alert Actions
    
    // Показать alert
    private func setAlert() {
        alertView = ConnectionAlertView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        view.addSubview(alertView)
        alertView.center = view.center
        view.isUserInteractionEnabled = false
    }
    
    // Убрать alert
    private func removeAlert() {
        UIView.animate(withDuration: 0.4) {
            self.alertView.alpha = 0
            self.alertView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        } completion: { _ in
            self.alertView.removeFromSuperview()
            self.view.isUserInteractionEnabled = true
        }
    }
    
    
    // Menu Actions
    
    // Показываем меню
    private func showMenu() {
        
        self.containerView.layer.cornerRadius = 50
        
        let x = UIScreen.main.bounds.width * 0.6 // можешь менять
        let originalTransform = self.containerView.transform
        let scaledTransform = originalTransform.scaledBy(x: 0.8, y: 0.8)
        let scaledAndTranslatedTransform = scaledTransform.translatedBy(x: x, y: 0)
        UIView.animate(withDuration: 0.7, animations: {
            self.containerView.transform = scaledAndTranslatedTransform
        })
    }
    
    // Прячем меню
    private func hideMenu() {
        
        UIView.animate(withDuration: 0.7, animations: {
            self.containerView.transform = self.home
            self.containerView.layer.cornerRadius = 0
        })
    }
    
    // Управляем меню свайпом
    private func addSwipeGestures() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeRightAction))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeftAction))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
    }
    
    
    // MARK: - Selectors
    
    @objc func startButtonTapped() {
        let calendar = Calendar.current
        let time = calendar.date(byAdding: .minute, value: 1, to: Date()) ?? Date()
        
        userDefaults.set(time, forKey: timerKey)
        userDefaults.set(true, forKey: isCountingKey)
        didCreateEvent(targetDate: time)
        
        startButton.isEnabled = false
        stopButton.isHidden = false
    }
    
    @objc func stopButtonTapped() {
        print("dfff")
        
        userDefaults.set(Date(), forKey: timerKey)
        userDefaults.set(false, forKey: isCountingKey)
        
        startButton.setTitle("Старт", for: .normal)
        startButton.isEnabled = true
        stopButton.isHidden = true
        
        sceduleTimer.invalidate()
        sceduleTimer = nil
    }
    
    
    // Menu selectors
    
    @objc func menuButtonTapped() {
        if !isMenuPresented {
            showMenu()
            isMenuPresented = true
        } else {
            hideMenu()
            isMenuPresented = false
        }
    }
    
    
    @objc func swipeRightAction() {
        if !isMenuPresented {
            showMenu()
            isMenuPresented = true
        }
    }
    
    @objc func swipeLeftAction() {
        if isMenuPresented {
            hideMenu()
            isMenuPresented = false
        }
    }
    
}




// MARK: - UITableViewDelegate, DataSource Extension

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuDataSourceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = menuDataSourceArray[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.backgroundColor = UIColor(named: "DarkGreenColor")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        switch indexPath.row {
        case 1:
            print("")
            let templatesVC = TemplatesViewController()
            let templatesNavVC = UINavigationController(rootViewController: templatesVC)
            //            templatesNavVC.modalPresentationStyle = .fullScreen
            
            templatesVC.startTimerAciton = { [weak self] model in
                
                guard let self = self else { return }
                
                self.lampScript = model.title
                
                let calendar = Calendar.current
                let time = calendar.date(byAdding: .minute, value: model.stopTimeIntMinutes, to: Date()) ?? Date()
                
//                self.stopTime = date
//                self.startTimer()
//                self.stopButton.isHidden = false
                
                
                self.sceduleTimer.invalidate()
                self.sceduleTimer = nil
                
                self.userDefaults.set(time, forKey: self.timerKey)
                self.userDefaults.set(true, forKey: self.isCountingKey)
                self.didCreateEvent(targetDate: time)
                
                self.startButton.isEnabled = false
                self.stopButton.isHidden = false
                
                
                
                self.switchLamp(red: model.red, green: model.green, blue: model.blue)
                
                self.isMenuPresented = false
                self.hideMenu()
            }
            present(templatesNavVC, animated: true)
            
        case 2:
            print("")
        case 3:
            print("")
        case 4:
            print("")
        default:
            break
        }
    }
}




// MARK: - MQTT Delegate Extension

extension MainViewController: CocoaMQTTDelegate {
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        print("didConnectAck: \(ack)")
        
        mqtt.subscribe(statusTopic)
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        print("didPublishMessage: \(message) and \(id)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        print("didReceiveMessage: \(message) and \(id)")
        
        if message.topic == statusTopic.replacingOccurrences(of: "/#", with: "") {
            guard let message = message.string else { fatalError() }
            if message == "0" {
                setAlert()
            } else if message == "1" {
                removeAlert()
            }
        }
    }
    
    
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topics: [String]) {
        print("didSubscribeTopic: \(topics)")
    }
    
    func mqttDidPing(_ mqtt: CocoaMQTT) {
        print("mqttDidPing")
    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        print("mqttDidReceivePong")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        print("didPublishAck : \(id)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishComplete id: UInt16) {
        print("didPublishComplete: \(id)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
        print("didSubscribeTopic: \(topic)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        print("didUnsubscribeTopic: \(topic)")
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        print("mqttDidDisconnect: \(err?.localizedDescription ?? "")")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceive trust: SecTrust, completionHandler: @escaping (Bool) -> Void) {
        print("didReceive trust")
    }
}




