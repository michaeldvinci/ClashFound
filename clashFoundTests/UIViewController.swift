//
//  UIViewController.swift
//  clashFoundW WatchKit Extension
//
//  Created by Mike Vinci on 9/5/22.
//

import UIKit
import WatchConnectivity//1

class ViewController: UIViewController {
  
  var session: WCSession?//2
  @IBOutlet weak var label: UILabel!//3
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    self.configureWatchKitSesstion()//4
  }
  
  func configureWatchKitSesstion() {
    
    if WCSession.isSupported() {//4.1
      session = WCSession.default//4.2
      session?.delegate = self//4.3
      session?.activate()//4.4
    }
  }
  //5
  @IBAction func tapSendDataToWatch(_ sender: Any) {
    
    if let validSession = self.session, validSession.isReachable {//5.1
      let data: [String: Any] = ["iPhone": "Data from iPhone" as Any] // Create your Dictionay as per uses
      validSession.sendMessage(data, replyHandler: nil, errorHandler: nil)
    }
  }
}

// WCSession delegate functions
extension ViewController: WCSessionDelegate {
  
  func sessionDidBecomeInactive(_ session: WCSession) {
  }
  
  func sessionDidDeactivate(_ session: WCSession) {
  }
  
  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
  }
  
  func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
    print("received message: \(message)")
    DispatchQueue.main.async { //6
      if let value = message["watch"] as? String {
        self.label.text = value
      }
    }
  }
}

