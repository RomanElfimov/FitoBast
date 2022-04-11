//
//  ViewController.swift
//  PhytoBast
//
//  Created by Роман Елфимов on 07.04.2022.
//

import UIKit
import CocoaMQTT

class ViewController: UIViewController {
    
    var mqtt: CocoaMQTT!
    var statusTopic: String = "FFF3/685F7B00685F7B00/status/#"
    
    
    var alertView = ConnectionAlertView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMQTT()
    }
    
    
    private func setAlert() {
        alertView = ConnectionAlertView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        view.addSubview(alertView)
        alertView.center = view.center
    }
    
    private func removeAlert() {
        UIView.animate(withDuration: 0.4) {
            self.alertView.alpha = 0
            self.alertView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        } completion: { _ in
            self.alertView.removeFromSuperview()
        }
        
    }
    
    
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
    
    
}




extension ViewController: CocoaMQTTDelegate {
    
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

