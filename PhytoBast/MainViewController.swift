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
    
    // menu
    private var home = CGAffineTransform()
    private var isMenuPresented = false
    private let menuDataSourceArray = ["", "Шаблоны", "Ручная настройка", "Избранное", "Журнал"] // Опции меню
    
    // timer
    //    public var timerDate: Date = Date()
    private var timerCounting: Bool = true
    private var stopTime: Date!
    private var sceduleTimer: Timer!
    
    private let userDefaults = UserDefaults.standard
    
    private let STOP_TIME_KEY = "startTime"
    private let COUNTING_KEY = "timerCounting"
    
    
    
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
    
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "DarkGreenColor")
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        button.setTitle("Старт", for: .normal)
        return button
    }()
    
    private lazy var favouritesButton: UIButton = {
        let button = UIButton()
        button.setTitle("Сценарий", for: .normal)
        button.backgroundColor = UIColor(named: "LightGreenColor")
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
        
        stopTime = userDefaults.object(forKey: STOP_TIME_KEY) as? Date
        timerCounting = userDefaults.bool(forKey: COUNTING_KEY)

        self.startTimer()
        
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
        //                mqtt.delegate = self
        mqtt.connect()
    }
    
    
    // Настройка таймера
    private func startTimer() {
        setTimerCounting(true)
        timerCounting = true
        setTime(date: stopTime)
        
        // mqtt turn on lights
    }
    
    func setTime(date: Date?) {
        userDefaults.set(date, forKey: STOP_TIME_KEY)
        sceduleTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(refreshValue), userInfo: nil, repeats: true)
    }
    
    func setTimerCounting(_ val: Bool) {
        timerCounting = val
        userDefaults.set(timerCounting, forKey: COUNTING_KEY)
    }
    
    @objc func refreshValue() {
        if timerCounting {
            let diff = Date().timeIntervalSince(stopTime)
            if Int(diff) >= Int(Date().timeIntervalSince(.now)) {
                sceduleTimer.invalidate()
                setTimerCounting(false)
                startButton.setTitle("Старт", for: .normal)
                // mqtt turn of lights
                return
            }
            setTimeLabel(Int(diff))
        }
    }
    
    
    // Настройка отображения времени
    func setTimeLabel(_ val: Int) {
        let time = secondsToHoursMinutesSeconds(val)
        let timeString = makeTimeString(hour: time.0, min: time.1, sec: time.2)
        startButton.setTitle(timeString, for: .normal)
    }
    
    func secondsToHoursMinutesSeconds(_ ms: Int) -> (Int, Int, Int) {
        let hour = ms / 3600
        let min = (ms % 3600) / 60
        let sec = (ms % 3600) % 60
        return (hour, min, sec)
    }
    
    func makeTimeString(hour: Int, min: Int, sec: Int) -> String {
        var timeString = ""
        timeString += String(format: "%02d", -hour)
        timeString += ":"
        timeString += String(format: "%02d", -min)
        timeString += ":"
        timeString += String(format: "%02d", -sec)
        return timeString.replacingOccurrences(of: "-", with: "")
    }
    
    
    @objc func startButtonTapped() {
        
        let calendar = Calendar.current
        stopTime = calendar.date(byAdding: .minute, value: 1, to: Date())! // просто для примера
        self.startTimer()
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
        
        
        // start button
        containerView.addSubview(startButton)
        startButton.centerX(inView: view)
        startButton.setDimensions(width: 200, height: 200)
        startButton.anchor(bottom: view.bottomAnchor, paddingBottom: 100)
        startButton.layer.cornerRadius = 100
        
        // favourites button
        containerView.addSubview(favouritesButton)
        favouritesButton.setDimensions(width: 120, height: 40)
        favouritesButton.layer.cornerRadius = 17
        favouritesButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingTop: 16, paddingRight: 16)
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
            
            templatesVC.startTimerAciton = { [weak self] date in
                
                self?.stopTime = date
                self?.startTimer()
                
                self?.isMenuPresented = false
                self?.hideMenu()
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




