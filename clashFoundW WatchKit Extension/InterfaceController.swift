//
//  InterfaceController.swift
//  clashFoundW WatchKit Extension
//
//  Created by Mike Vinci on 9/5/22.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController {
    @IBOutlet var table: WKInterfaceTable!
    @IBOutlet var label: WKInterfaceLabel!
    @IBOutlet weak var timeLabel: WKInterfaceLabel!
    let session = WCSession.default
    var testUp: [String] = ["no schedule", "loaded"]
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        configSession()
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    func configSession() {
        session.delegate = self
        session.activate()
        print("watch sesh activated")
    }
    
    func loadTable(array: [String]) {
        table.setNumberOfRows(array.count,
            withRowType: "rowController")
        for (index, labelText) in array.enumerated() {
            let row = table.rowController(at: index) as! RowController
            row.rowLabel.setText(labelText)
        }
    }

    override init() {
        super.init()
        loadTable(array: testUp)
    }
}

extension InterfaceController: WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if error == nil {
            print("activated: \(activationState)")
        } else {
            print(error!.localizedDescription)
        }
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
//        print(session)
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        replyHandler(["title": "received successfully", "replyContent": "This is a reply from watch"])
        DispatchQueue.main.sync {
            if let valueFromPhone = message["phone"] {
                let toGet = valueFromPhone as! [String]
                table.setNumberOfRows(toGet.count,
                    withRowType: "rowController")
                for (index, labelText) in toGet.enumerated() {
                    let row = table.rowController(at: index) as! RowController
                    row.rowLabel.setText(labelText)
                }
            } else { }
        }
    }
}
