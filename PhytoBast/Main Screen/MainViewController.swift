//
//  ViewController.swift
//  PhytoBast
//
//  Created by Роман Елфимов on 07.04.2022.
//

import UIKit
import CocoaMQTT
import Lottie
import RealmSwift

class MainViewController: UIViewController {
    
    // MARK: - Priavte Properties
    
    private let realm = try! Realm()
    private var currentScriptArray: Results<CurrentTemplateModel>!
    
    // mqtt
    private var mqtt: CocoaMQTT!
    private let statusTopic: String = "FFF3/685F7B00685F7B00/status/#" // Топик для статуса устройства
    private let messageTopic: String = "FFF3/685F7B00685F7B00/api/v1/led/all/[0,5]" // Топик для сообщений
    
    // menu
    private var home = CGAffineTransform()
    private var isMenuPresented = false
    private let menuDataSourceArray = ["", "Шаблоны", "Ручная настройка", "Избранное"] // Опции меню

    
    // timer
    private var isTimerCounting: Bool = true
    private var stopTime: Date = Date()
    private var sceduleTimer: Timer!
    
    // user defaults
    private let userDefaults = UserDefaults.standard
    
    private let topTimeKey = "startTime"
    private let countingKey = "timerCounting"
    private let lampScriptKey = "lampScript"
    
    
    
    // MARK: - Interface Properties
    
    private var scriptPopVC: PopoverScriptTableViewController!
    
    private var alertView = ConnectionAlertView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
    
    private var menuTableView: UITableView!
    private let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
    
    
    private lazy var menuButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "menuIcon"), for: .normal)
        button.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let logoAnimationView = AnimationView(name: "leaves")
    
    private lazy var logoLabel: UILabel = {
        let label = UILabel()
        label.text = "Fito Bast"
        label.textAlignment = .center
        label.textColor = UIColor(named: "GreenWhite")
        label.font = UIFont(name: "Snell Roundhand Bold", size: 54)
        return label
    }()
    
    private lazy var scriptsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Сценарий", for: .normal)
        button.backgroundColor = UIColor(named: "LightGreen")
        button.addTarget(self, action: #selector(scriptsButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var scriptLabel: UILabel = {
        let label = UILabel()
        label.text = "Мой сценарий 1"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.textColor = UIColor(named: "GreenWhite")
        return label
    }()
    
    
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "LightGreen")
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        button.setTitle("Старт", for: .normal)
        return button
    }()
    
    
    private lazy var stopButton: UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor(named: "LightGreen")?.cgColor
        button.layer.borderWidth = 2
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        button.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
        button.setTitle("Стоп", for: .normal)
        button.setTitleColor(UIColor(named: "GreenWhite"), for: .normal)
        return button
    }()
    
  
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMQTT()
        setupUI()
        
        currentScriptArray = realm.objects(CurrentTemplateModel.self)
        
        stopTime = userDefaults.object(forKey: topTimeKey) as? Date ?? Date()
        isTimerCounting = userDefaults.bool(forKey: countingKey)
        stopButton.isHidden = true
        
        if isTimerCounting {
            self.startTimer()
        }
        
        scriptLabel.text = currentScriptArray.isEmpty ? "" : currentScriptArray[0].title
    }
    
    
    // MARK: - UI Setup
    
    // Настраиваем элементы интерфейса
    private func setupUI() {
        
        // menu
    
        menuTableView = UITableView()
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        view.addSubview(menuTableView)
        menuTableView.frame = view.bounds
        
        menuTableView.separatorStyle = .none
        menuTableView.rowHeight = 90
        menuTableView.backgroundColor = .white
        
        home = self.containerView.transform
        menuTableView.backgroundColor = UIColor(named: "DarkGreenColor")
        addSwipeGestures()
        
        // container view
        view.addSubview(containerView)
        containerView.frame = view.bounds
        containerView.backgroundColor = UIColor(named: "BackgroundColor")
        
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
        containerView.addSubview(scriptsButton)
        scriptsButton.setDimensions(width: 120, height: 40)
        scriptsButton.layer.cornerRadius = 17
        scriptsButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingTop: 16, paddingRight: 16)
        
        // script label
        containerView.addSubview(scriptLabel)
        scriptLabel.centerX(inView: view)
        scriptLabel.anchor(top: logoLabel.bottomAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor,  paddingTop: 24, height: 50)
        
        // start button
        containerView.addSubview(startButton)
        containerView.addSubview(stopButton)
        
        startButton.centerX(inView: view)
        let dimension = UIScreen.main.bounds.width / 2.7
        startButton.setDimensions(width: dimension, height: dimension)
        startButton.anchor(top: scriptLabel.bottomAnchor, paddingTop: 28)
        startButton.layer.cornerRadius = dimension / 2
        startButton.titleLabel?.minimumScaleFactor = 0.6
        
        // stop button
        stopButton.centerX(inView: view)
        stopButton.setDimensions(width: 200, height: 60)
        stopButton.anchor(bottom: view.bottomAnchor, paddingBottom: 50)
        stopButton.layer.cornerRadius = 16
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
                                mqtt.delegate = self
        mqtt.connect()
    }
    
    
    // Переключение лампы
    private func switchLamp(red: Int, green: Int, blue: Int) {
        let messageDictionary : [String: Any] = [ "red": red, "green": green, "blue": blue]
        let jsonData = try! JSONSerialization.data(withJSONObject: messageDictionary, options: [])
        let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)!
        
        let message = CocoaMQTTMessage(topic: messageTopic, string: jsonString)
        mqtt.publish(message)
    }
    
    
    // Timer Actions
    
    // Настройка таймера
    private func startTimer() {
        setTimerCounting(true)
        isTimerCounting = true
        setTime(date: stopTime)
        stopButton.isHidden = false
    }
    
    private func stopTimer() {
        if sceduleTimer != nil {
            sceduleTimer.invalidate()
        }
        setTimerCounting(false)
        startButton.setTitle("Старт", for: .normal)
        startButton.isUserInteractionEnabled = true
        
        // mqtt turn off lights
        switchLamp(red: 0, green: 0, blue: 0)
        
        // hide stop button
        stopButton.isHidden = true
    }
    
    private func makeDate(from value: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .minute, value: value, to: Date())!
    }
    
    private func setTime(date: Date?) {
        userDefaults.set(date, forKey: topTimeKey)
        sceduleTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(refreshValue), userInfo: nil, repeats: true)
    }
    
    private func setTimerCounting(_ val: Bool) {
        isTimerCounting = val
        userDefaults.set(isTimerCounting, forKey: countingKey)
    }
    
    @objc func refreshValue() {
        if isTimerCounting {
            let diff = Date().timeIntervalSince(stopTime)
            if Int(diff) >= Int(Date().timeIntervalSince(.now)) {
            
                stopTimer()
                return
            }
            setTimeLabel(Int(diff))
        }
    }
    
    
    // Настройка отображения времени
    private func setTimeLabel(_ val: Int) {
        let time = secondsToHoursMinutesSeconds(val)
        let timeString = makeTimeString(hour: time.0, min: time.1, sec: time.2)
        startButton.setTitle(timeString, for: .normal)
        startButton.isUserInteractionEnabled = false
    }
    
    private func secondsToHoursMinutesSeconds(_ ms: Int) -> (Int, Int, Int) {
        let hour = ms / 3600
        let min = (ms % 3600) / 60
        let sec = (ms % 3600) % 60
        return (hour, min, sec)
    }
    
    private func makeTimeString(hour: Int, min: Int, sec: Int) -> String {
        var timeString = ""
        timeString += String(format: "%02d", -hour)
        timeString += ":"
        timeString += String(format: "%02d", -min)
        timeString += ":"
        timeString += String(format: "%02d", -sec)
        return timeString.replacingOccurrences(of: "-", with: "")
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
        
        if currentScriptArray.isEmpty {
            let alertController = UIAlertController(title: "Выберите сценарий", message: "Для управления устройством необходимо выбрать сценарий", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ок", style: .default)
            alertController.addAction(okAction)
            present(alertController, animated: true)
            return
        }
        
        let currentScript = currentScriptArray[0]
        stopTime = makeDate(from: currentScript.stopTime)
    
        self.startTimer()
        
        // mqtt turn on lights
        switchLamp(red: currentScript.red, green: currentScript.green, blue: currentScript.blue)
    }
    
    @objc func stopButtonTapped() {
        stopTimer()
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
    
    
    // Действие для кнопки "Сценарий"
    @objc func scriptsButtonTapped() {
        scriptPopVC = PopoverScriptTableViewController()
        scriptPopVC.modalPresentationStyle = .popover
        
        let popOverVC = scriptPopVC.popoverPresentationController
        popOverVC?.delegate = self
        
        popOverVC?.sourceView = scriptsButton
        popOverVC?.sourceRect = CGRect(x: scriptsButton.bounds.midX - 50, y: scriptsButton.bounds.midY, width: 0, height: 0)
        scriptPopVC.preferredContentSize = CGSize(width: 200, height: 150)
        
        scriptPopVC.completion = { [weak self] templateModel in
            guard let self = self else { return }
            
            self.scriptLabel.text = templateModel.title
            
            let currentScript = CurrentTemplateModel(title: templateModel.title, red: templateModel.red, green: templateModel.green, blue: templateModel.blue, stopTime: templateModel.stopTime)

            try! self.realm.write {
                self.realm.delete(Array(self.currentScriptArray))
                self.realm.add(currentScript)
            }
            
            if self.isTimerCounting {
                self.stopTimer()
            }
        }
        
        present(scriptPopVC, animated: true)
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
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 1:
            let templatesVC = TemplatesViewController()
            let templatesNavVC = UINavigationController(rootViewController: templatesVC)
                        templatesNavVC.modalPresentationStyle = .fullScreen
            
            // Действие для кнопки "Начать" в ячейке
            templatesVC.startTimerAciton = { [weak self] templateModel in
                guard let self = self else { return }
     
                self.stopTime = self.makeDate(from: templateModel.stopTime)
                self.startTimer()
                self.scriptLabel.text = templateModel.title
                
                let currentScript = CurrentTemplateModel(title: templateModel.title, red: templateModel.red, green: templateModel.green, blue: templateModel.blue, stopTime: templateModel.stopTime)
                try! self.realm.write {
                    self.realm.delete(Array(self.currentScriptArray))
                    self.realm.add(currentScript)
                }
                
                self.switchLamp(red: templateModel.red, green: templateModel.green, blue: templateModel.blue)
                self.isMenuPresented = false
                self.hideMenu()
            }
            present(templatesNavVC, animated: true)
            
        case 2:
            
            let manualTemplatesVC = ManualTemplatesViewController()
            let manualTemplatesNavVC = UINavigationController(rootViewController: manualTemplatesVC)
            manualTemplatesNavVC.modalPresentationStyle = .fullScreen
            
            // Действие для кнопки "Показать на устройстве"
            manualTemplatesVC.showOnDeviceAction = { [weak self] red, green, blue in
                self?.stopTimer()
                self?.switchLamp(red: red, green: green, blue: blue)
            }
            
            present(manualTemplatesNavVC, animated: true, completion: nil)
            
        case 3:
            let favouritesVC = FavouritesViewController()
            let favouritesNavVC = UINavigationController(rootViewController: favouritesVC)
                        favouritesNavVC.modalPresentationStyle = .fullScreen
            present(favouritesNavVC, animated: true, completion: nil)
        
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
        mqtt.subscribe(messageTopic)
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        print("didPublishMessage: \(message) and \(id)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        print("didReceiveMessage: \(message) and \(id)")
        
        if message.topic == statusTopic.replacingOccurrences(of: "/#", with: "") {
            guard let message = message.string else { return }
            if message == "0" {
                setAlert()
            } else if message == "1" {
                removeAlert()
                print("Here")
            }
            print(message)
        }
    }
    
    
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topics: [String]) {}
    
    func mqttDidPing(_ mqtt: CocoaMQTT) {}
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {}
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {}
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishComplete id: UInt16) {}
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String) {}
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {}
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {}
    
    func mqtt(_ mqtt: CocoaMQTT, didReceive trust: SecTrust, completionHandler: @escaping (Bool) -> Void) {}
}






// MARK: - Extension PopoverPresentation

extension MainViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
