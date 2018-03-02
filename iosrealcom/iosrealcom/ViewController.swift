//
//  ViewController.swift
//  iosrealcom
//
//  Created by lakshmana on 01/03/18.
//  Copyright © 2018 nearhop. All rights reserved.
//

import UIKit
import SwiftWebSocket

class ViewController: UIViewController {

    var ws : WebSocket!

    @IBOutlet weak var messages: UITextView!
    @IBOutlet weak var sendMessage: UITextField!
    @IBOutlet weak var sendMe: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        let ctap = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(ctap)
        openWebSokcet();
        let stap = UITapGestureRecognizer(target: self, action: #selector(ViewController.sendMessageFromClient))
        sendMe.isUserInteractionEnabled = true
        sendMe.addGestureRecognizer(stap)
        self.sendMessage.autocorrectionType = .no
        self.messages.isEditable = false
        
    }
        // Do any additional setup after loading the view, typically from a nib.

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func openWebSokcet(){
        ws = WebSocket("ws://192.168.2.102:5857")
        ws.event.open = {
            DispatchQueue.main.async() {
                self.messages.text = "Hi\n";
            }
            let when2 = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when2) {
                self.sendFirstMessage();
            }
        }
        ws.event.close = { code, reason, clean in
            print("close")
        }
        ws.event.error = { error in
            print("error \(error)")
        }
        ws.event.message = { message in
            if let text = message as? String {
                DispatchQueue.main.async() {
//                    self.messagesText.text =  self.messagesText.text! + text + "\n"
                    var etext = self.messages.text;
                    self.messages.text =  text + "\n"
//                    self.messagesText.text = (self.messagesText.text ?? "") + text + "\n"
//                    self.messagesText.numberOfLines = +1
                    self.messages.text =  etext! + text + "\n"
                    var myText = self.messages.text;
                    var a = 1;
                }
            }
        }
    }
    @objc func sendMessageFromClient(){
        DispatchQueue.main.async() {
            var enteredText =  self.sendMessage.text;
            self.messages.text =  self.messages.text! + enteredText! + "\n"
            self.sendMessage.text = ""
        }
        ws.send(self.sendMessage.text)
    }
    
    func sendFirstMessage(){
        ws.send("nearhop_ios")
    }
}

