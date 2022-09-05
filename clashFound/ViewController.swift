//
//  ViewController.swift
//  clashFound
//
//  Created by Mike Vinci on 9/4/22.
//

import UIKit
import SwiftSoup
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate, UITextViewDelegate {
    @IBOutlet var field: UITextField!
    @IBOutlet var button: UIButton!
    @IBOutlet var buttonSend: UIButton!
    @IBOutlet var textView: UITextView!
    @IBOutlet var scrollView: UIScrollView!
    var session: WCSession?
    var toWatch: [String] = []
    
    let htmlTest = "https://michaeldvinci.com"
    var linkSaved = ""
    var linkText = ""
    var linkM = ""
    var linkU = ""
    var linkUnescaped = ""
    var linkEscaped = ""
    var linkA: [Element] = []
    var actObj: Act!
    var config: [Act] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWatchSession()
        textView.delegate = self
    }
    
    func debugAct(actObj: Act) {
        print("---------------------------------")
        print("actObj.name : \(actObj.name)")
        print("actObj.day : \(actObj.day)")
        print("actObj.time : \(actObj.time)")
        print("actObj.stage : \(actObj.stage)")
        print("---------------------------------")
    }
    
    func sendToWatch() {
        if !WCSession.default.isReachable {
            let alert = UIAlertController(title: "Failed", message: "Apple Watch is not reachable.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
        } else {
            // The counterpart is not available for living messageing
            print("no sesh")
        }
        let message = ["title": "iPhone send a message to Apple Watch", "phone": toWatch] as [String : Any]
        WCSession.default.sendMessage(message, replyHandler: { (replyMessage) in
            print(replyMessage)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    @IBAction func buttonSendTapped() {
        print("pressed")
        sendToWatch()
    }

    @IBAction func buttonTapped() {
        toWatch = []
        config = []
        self.textView.text = nil
        textView.textContainerInset = .zero
        if field.text == "" {
            print("nope")
        } else {
            print("pressed: \(field.text!)")
            linkSaved = field.text!
            if linkSaved.contains("?user") {
                let linkEnd = linkSaved.index(of: "/?")
                let nextIndex = linkSaved.index(linkEnd!, offsetBy: 1)
                let prefix = linkSaved[...linkEnd!]
                let end = linkSaved[nextIndex...]
                print("Prefix: \(prefix)")
                print("End: \(end)")
                linkSaved = prefix + String(end)
                print("linkSaved: \(linkSaved)")
            }
            if linkSaved.contains("/m/") {
                linkM = linkSaved.replacingOccurrences(of: "/m/", with: "/s/")
                print(linkM)
            } else { linkM = linkSaved }
            print("LinkM \(linkM)")
            let html = parseHTML(urlString: linkM)
            if !(html == "") {
                do {
                    let doc = try SwiftSoup.parse(html)
                    let daysElements: Elements = try doc.getElementsByClass("days")
                    let dayElements: Elements = try daysElements[0].getElementsByClass("day")
                    for day in dayElements {
                        actObj = Act()
                        let dayNameElements: Elements = try day.getElementsByClass("headingDayName")
                        let dayName: String = try dayNameElements[0].text()
                        actObj.day = dayName
                        toWatch.append("\(dayName)\n")
                        textView.insertText("\(dayName)\n")
                        let stageElements: Elements = try day.getElementsByClass("stageContainer")
                        for stage in stageElements {
                            let stageNameElements: Elements = try stage.getElementsByClass("stageName")
                            let stageName: String = try stageNameElements[0].text()
                            actObj.stage = stageName
                            toWatch.append("\(stageName)\n")
                            textView.insertText("\(stageName)\n")
                            do {
                                let actElement: Elements = try stage.getElementsByClass("act")
                                for act in actElement {
//                                    print(act)
                                    do {
                                        let actNameElements: Elements = try act.getElementsByClass("actNm")
                                        if actNameElements.count > 0 {
                                            let actName: String = try actNameElements[0].text()
                                            textView.insertText("   \(actName)\n")
                                            actObj.name = actName
                                            toWatch.append("   \(actName)\n")
                                        }
                                    } catch {
                                        print("no name stored")
                                    }
                                    do {
                                        let actTimeElements: Elements = try act.getElementsByClass("actTime")
                                        if actTimeElements.count > 0 {
                                            let actTime: String = try actTimeElements[0].text()
                                            textView.insertText("     \(actTime)\n")
                                            actObj.time = actTime
                                            toWatch.append("     \(actTime)\n")
                                        }
                                    } catch {
                                        print("no time stored")
                                    }
                                    do {
                                        let actSavedElements: Elements = try act.getElementsByClass("jqHlWrap")
                                        if actSavedElements.count > 0 {
                                            for save in actSavedElements {
                                                print("save: \(save)")
                                            }
                                        }
                                    } catch {
                                        print("no saved stored")
                                    }
//                                    debugAct(actObj: actObj)
                                    config.append(actObj)
                                }
                            } catch {
                                print("This should be an error")
                            }
                        }
                    }
                }
            catch {
                print("This should be an error") }
            } else { print("html doesn't html")}
        }
    }
    
    func setupWatchSession() {
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        textView.text = String()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        //
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        //
    }
}

